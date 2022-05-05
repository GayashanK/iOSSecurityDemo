//
//  ViewController.swift
//  DataProtectionDemo
//
//  Created by Kasun Gayashan on 07.02.22.
//  Copyright © 2022 Nyisztor, Karoly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let text = "Super Secret Text"
        if let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("protecteddata.txt") {
            let result = secureSave(text: text, fileURL: fileURL)
            let message = result ? "save successfully" : "save failed"
            print(message)
        }
    }

    private func secureSave(text: String, fileURL: URL) -> Bool {
        guard let data = text.data(using: .utf8) else {
            return false
        }
        
        do {
            try data.write(to: fileURL, options: .completeFileProtectionUnlessOpen)
            return true
        } catch {
            print(error)
            return false
        }
    }

}

