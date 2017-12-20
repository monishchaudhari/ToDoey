//
//  AppDelegate.swift
//  ToDoey
//
//  Created by Monish Chaudhari on 18/12/17.
//  Copyright © 2017 Monish Chaudhari. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        print("~~~~~~~~~~~~~~~~~~~~~~App launched~~~~~~~~~~~~~~~~~~~~~")
        
        do {
            _ = try Realm()

        } catch {
            print("Error in Realm Initialization: \(error)")
        }
        return true
    }
    
}

