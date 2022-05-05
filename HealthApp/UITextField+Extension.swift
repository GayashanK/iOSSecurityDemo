//
//  UITextField+Extension.swift
//  HealthApp
//
//  Created by Kasun Gayashan on 06.02.22.
//  Copyright © 2022 Nyisztor, Karoly. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
   
    override open func copy(_ sender: Any?) {
//        super.copy(sender) // Todo - Copy and Paste part of the text
        AppDelegate.healthAppPasteBoard?.string = self.text
//        UIPasteboard.general.items = [[String: Any]()]
    }

    override open func cut(_ sender: Any?) {
//        super.cut(sender)
        AppDelegate.healthAppPasteBoard?.string = self.text
        self.text = nil
//        UIPasteboard.general.items = [[String: Any]()]
    }

    override open func paste(_ sender: Any?) {
        if let text = AppDelegate.healthAppPasteBoard?.string {
            self.text = text
        }
    }
}
