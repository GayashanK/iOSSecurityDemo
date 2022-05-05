//
//  ViewController.swift
//  AsymmetricCryptoDemo
//
//  Created by Kasun Gayashan on 09.02.22.
//  Copyright © 2022 Nyisztor, Karoly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.encryptDecrypt()
    }
    
    private func encryptDecrypt() {
        let facade = KeychainFacade()
        let text = "Super Secret Text"
        
        do {
            if let encryptedData = try facade.encrypt(text: text) {
                print("Text Encryption Successful")
                if let decrypetData = try facade.decrypt(data: encryptedData) {
                    print("Text Decryption Successful")
                    print(String.init(data: decrypetData, encoding: .utf8) ?? "fail")
                }
            }
        } catch {
            print(error)
        }
    }


}

