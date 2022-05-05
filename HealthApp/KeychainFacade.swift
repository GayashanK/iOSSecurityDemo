//
//  KeychainFacade.swift
//  HealthApp
//
//  Created by Kasun Gayashan on 07.02.22.
//  Copyright © 2022 Nyisztor, Karoly. All rights reserved.
//

import Foundation
import Security

public enum KeychainFacadeError: Error {
    case invalidContent
    case failure(status: OSStatus)
}

class KeychainFacade {
    
    private func setUpQueryDictionary(forKey key: String)-> [String: Any] {
        var queryDictonary = [String: Any]()
        queryDictonary[kSecClass as String] = kSecClassGenericPassword
        queryDictonary[kSecAttrAccount as String] = key.data(using: .utf8)
        return queryDictonary
    }
    
    public func set(string: String, forKey key: String) throws {
        guard !string.isEmpty || !key.isEmpty else {
            print("cannot add empty string or key to the keychain")
            throw KeychainFacadeError.invalidContent
        }
        
        try? self.remove(forKey: key)
        
        var queryDictonary = setUpQueryDictionary(forKey: key)
        queryDictonary[kSecValueData as String] = string.data(using: .utf8)
        let status = SecItemAdd(queryDictonary as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeychainFacadeError.failure(status: status)
        }
    }
    
    public func remove(forKey key: String) throws {
        guard !key.isEmpty else {
            print("Key mush be valid")
            throw KeychainFacadeError.invalidContent
        }
        
        let queryDictonary = setUpQueryDictionary(forKey: key)
        let status = SecItemDelete(queryDictonary as CFDictionary)
        if status != errSecSuccess {
            throw KeychainFacadeError.failure(status: status)
        }
    }
    
    public func string(forKey key: String) throws -> String? {
        guard !key.isEmpty else {
            throw KeychainFacadeError.invalidContent
        }
        
        var queryDictionary = setUpQueryDictionary(forKey: key)
        queryDictionary[kSecReturnData as String] = kCFBooleanTrue
        queryDictionary[kSecMatchLimit as String] = kSecMatchLimitOne
        var data: AnyObject?
        let status = SecItemCopyMatching(queryDictionary as CFDictionary, &data)
        if status != errSecSuccess {
            throw KeychainFacadeError.failure(status: status)
        }
        let result: String?
        if let itemData = data as? Data {
            result = String(data: itemData, encoding: .utf8)
            return result
        } else {
            return nil
        }
    }
}


