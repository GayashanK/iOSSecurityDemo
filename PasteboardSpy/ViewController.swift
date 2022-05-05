//
//  ViewController.swift
//  PasteboardSpy
//
//  Created by Kasun Gayashan on 05.02.22.
//  Copyright © 2022 Nyisztor, Karoly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pasteBoardContent = UIPasteboard.general.string ?? "PasteBoard is empty"
        self.textView.text = pasteBoardContent
    }
}

