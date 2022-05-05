//
//  AppDelegate.swift
//  HealthApp
//
//  Created by Nyisztor, Karoly on 8/4/18.
//  Copyright © 2018 Nyisztor, Karoly. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var healthAppPasteBoard = UIPasteboard(name: UIPasteboardName(rawValue: "HealthAppPasteBoard"), create: true)
    // Option 2 - Obstructing the snapshot
    lazy var splashView: UIImageView = {
        let imageView = UIImageView(frame: self.window!.frame)
        imageView.backgroundColor = .green
        return imageView
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Option 1 - remove all paste board content
//        UIPasteboard.general.items = [[String: Any]()]
        self.window?.addSubview(splashView)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        splashView.removeFromSuperview()
    }
}

