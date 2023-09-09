//
//  AppNavigator.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import UIKit

class AppNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

}

class AppNavigator {

    static let shared = AppNavigator()

    private(set) var window: UIWindow!
    private var needMakeKeyAndVisible = true

    func setupRootNavigationInWindow(_ window: UIWindow) {
        self.window = window
        let navigationVC = AppNavigationController(rootViewController: MainViewController())
        window.rootViewController = navigationVC
    }

}

