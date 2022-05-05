//
//  ViewController.swift
//  BiomatricDemo
//
//  Created by Kasun Gayashan on 09.02.22.
//  Copyright © 2022 Nyisztor, Karoly. All rights reserved.
//

import UIKit
import LocalAuthentication

enum LocalAuthticationError: Error {
    case authenticationFailed
    case forwarded(Error)
    case unknown
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authentication { error in
            
            var title = "Successful"
            var message = "You logged in using touch id"
            
            if let error = error {
                title = "Failure"
                message = "Could not authenticate using touch id: reason - \(error.localizedDescription)"
            }
            
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let dismissionAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(dismissionAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
//        let authenticationContext = LAContext()
//        var localAuthenticationError: NSError?
//        if authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &localAuthenticationError) {
//            localAuthenticationError == nil {
//                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, //this runs on praivate queue
//                    localizedReason: "Log in with Touch ID") { success, error in
//                    var title = "Successful"
//                    var message = "You logged in using touch id"
//
//                    if error != nil || !success {
//                        title = "Failure"
//                        var message = "Could not authenticate using touch id: reason - \(error?.localizedDescription ?? "unknown")"
//                    }
//
//                    DispatchQueue.main.async {
//                        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//                        let dismissionAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//                        self.present(alertController, animated: true, completion: nil)
//                    }
//                }
//            } else {
//                print(localAuthenticationError)
//            }
//        }
    }
    
    private func authentication(completion: @escaping(_ error: Error?)->Void) {
        let authenticationContext = LAContext()
        var localAuthenticationError: NSError?
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &localAuthenticationError) {
            var reason: String
            switch authenticationContext.biometryType {
            case .faceID:
                reason = "Login with Face ID"
                break
            case .touchID:
                reason = "Login with Touch ID"
                break
            default:
                reason = "Login with Passcode"
                break
            }
    
            authenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if let error = error {
                    completion(LocalAuthticationError.forwarded(error))
                }
                
                if !success {
                    completion(LocalAuthticationError.unknown)
                }

                if success {
                    completion(nil)
                }
            }
        } else {
            completion(LocalAuthticationError.authenticationFailed)
        }
    }


}

