//
//  ViewController.swift
//  HealthApp
//
//  Created by Nyisztor, Karoly on 8/4/18.
//  Copyright © 2018 Nyisztor, Karoly. All rights reserved.
//

import UIKit
import HealthKit

enum PermissionError: Error {
    case stepDataReadError
}

class ViewController: UIViewController {
    
    lazy var keyChain = KeychainFacade()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userName = try? keyChain.string(forKey: "username"),let password = try? keyChain.string(forKey: "password") else {
            print("Couldn't retrive the credentials form the keychain")
            return
        }
        
        print("username \(userName) password \(password)")
        
        // Option 1 - For snapshot data leakage
        NotificationCenter.default.addObserver(forName: .UIApplicationWillResignActive, object: nil, queue: .main) { _ in
            for view in self.view.subviews {
                if let view = view as? UITextField {
                    view.text = nil
                }
            }
            
        }
        
        if HKHealthStore.isHealthDataAvailable() {
            self.requestPermission { success, error in
                if success {
                    self.queryTodaysSteps { (steps) in
                        print(steps)
                    }
                } else {
                    print(error ?? "Unknown error")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewDidDisappear(animated)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
//        UserDefaults.standard.set("Kasun Gayashan", forKey: "username")
//        UserDefaults.standard.set("passwordkasun", forKey: "password")
        do {
            try keyChain.set(string: "KasunG", forKey: "username")
            try keyChain.set(string: "passwordkasun", forKey: "password")
        } catch let facadeError as KeychainFacadeError {
            print(facadeError.localizedDescription)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func requestPermission(completion: @escaping(Bool,Error?) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(false, PermissionError.stepDataReadError)
            return
        }
        
        let types = Set([stepQuantityType])
        let healthStore = HKHealthStore()
        healthStore.requestAuthorization(toShare: nil, read: types) { success, error in
            completion(success, error)
        }
    }
    
    private func queryTodaysSteps(completion: @escaping (Double) -> Void) {
        let today = Date()
        let startOfDay = Calendar.current.startOfDay(for: today)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: today, options: .strictStartDate)

        guard let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(0)
            return
        }
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: HKStatisticsOptions.cumulativeSum) { (statsQuery, result, error) in
            if let queryError = error {
                print(queryError)
                completion(0)
                return
            }
            
            guard let steps = result?.sumQuantity() else {
                completion(0)
                return
            }
            
            completion(steps.doubleValue(for: HKUnit.count()))
        }
        
        let healthStore = HKHealthStore()
        healthStore.execute(query)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

