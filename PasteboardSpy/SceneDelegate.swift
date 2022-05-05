//
//  SceneDelegate.swift
//  PasteboardSpy
//
//  Created by Kasun Gayashan on 05.02.22.
//  Copyright © 2022 Nyisztor, Karoly. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

