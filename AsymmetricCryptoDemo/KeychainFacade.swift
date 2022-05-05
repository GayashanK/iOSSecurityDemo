//
//  KeychainFacade.swift
//  AsymmetricCryptoDemo
//
//  Created by Kasun Gayashan on 09.02.22.
//  Copyright © 2022 Nyisztor, Karoly. All rights reserved.
//

import Foundation
import Security

enum KeychainFacadeError: Error {
    case keyGenerationError
    case forwarded(Error)
    case unknown
    case failure(status: OSStatus)
    case noPublicKey
    case unsupported(algorithm: SecKeyAlgorithm)
    case unsupportedInput
    case noPrivateKey
}

class KeychainFacade {
    
    lazy var privateKey: SecKey? = {
        guard let key = try? retrivePrivateKey() else {
            return try? generatePrivateKey()
        }
        return key
    }()
    
    lazy var publicKey: SecKey? = {
        guard let key = privateKey else {
            return nil
        }
        return SecKeyCopyPublicKey(key)
    }()
    
    private static let tagData = "com.gayashan.asymmetriccryptodemo.key.mykey".data(using: .utf8)
    private let keyAttributes: [String: Any] = [kSecAttrType as String: kSecAttrKeyTypeRSA,
                                                kSecAttrKeySizeInBits as String: 2048,
                                                kSecAttrApplicationTag as String: tagData!,
                                                kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: true]]
    var keyGenerationError: Unmanaged<CFError>?
    private func generatePrivateKey() throws -> SecKey? {
        guard let privateKey = SecKeyCreateRandomKey(keyAttributes as CFDictionary, &keyGenerationError) else {
            if let error = keyGenerationError {
                throw KeychainFacadeError.forwarded(error.takeRetainedValue() as Error)
            } else {
                throw KeychainFacadeError.unknown
            }
        }
        
        return privateKey
    }
    
    private func retrivePrivateKey() throws -> SecKey? {
        let privateKeyQuery: [String: Any] = [kSecClass as String: kSecClassKey,
                                              kSecAttrApplicationTag as String: KeychainFacade.tagData!,
                                              kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                              kSecReturnRef as String: true]
        var privateKeyRef: CFTypeRef?
        let status = SecItemCopyMatching(privateKeyQuery as CFDictionary, &privateKeyRef)
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                return nil
            } else {
                throw KeychainFacadeError.failure(status: status)
            }
        }
        
        return privateKeyRef != nil ? (privateKeyRef as! SecKey) : nil
    }
    
    func encrypt(text: String) throws -> Data? {
        guard let key = publicKey else {
            throw KeychainFacadeError.noPublicKey
        }
        
        let algorithm = SecKeyAlgorithm.rsaEncryptionOAEPSHA512
        guard SecKeyIsAlgorithmSupported(key, .encrypt, algorithm) else {
            throw KeychainFacadeError.unsupported(algorithm: algorithm)
        }
        
        var ciperGenerationError: Unmanaged<CFError>?
        guard let data = text.data(using: .utf8) else {
            throw KeychainFacadeError.unsupportedInput
        }
        
        guard let encryptedData: Data = SecKeyCreateEncryptedData(key, algorithm, data as CFData, &ciperGenerationError) as Data? else {
            if let error = ciperGenerationError {
                throw KeychainFacadeError.forwarded(error.takeRetainedValue() as Error)
            } else {
                throw KeychainFacadeError.unknown
            }
        }
        
        return encryptedData
    }
    
    func decrypt(data: Data) throws -> Data? {
        guard let key = privateKey else {
            throw KeychainFacadeError.noPrivateKey
        }
        
        let algorithm = SecKeyAlgorithm.rsaEncryptionOAEPSHA512
        guard SecKeyIsAlgorithmSupported(key, .decrypt, algorithm) else {
            throw KeychainFacadeError.unsupported(algorithm: algorithm)
        }
        
        var plainDataGenerationError: Unmanaged<CFError>?
        guard let decryptedData: Data = SecKeyCreateDecryptedData(key, algorithm, data as CFData, &plainDataGenerationError) as Data? else {
            if let error = plainDataGenerationError {
                throw KeychainFacadeError.forwarded(error.takeRetainedValue() as Error)
            } else {
                throw KeychainFacadeError.unknown
            }
        }
        
        return decryptedData
    }
}
