//
//  AppDelegate.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
private let appNavigator = AppNavigator.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        appNavigator.setupRootNavigationInWindow(window!)
        window?.makeKeyAndVisible()
        return true
    }

}

