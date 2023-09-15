//
//  UIViewController+Convenience.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import SafariServices

extension UIViewController {

    func applyDefaultSettings(withBackgroundColor color: UIColor = .appBackground) {
        view.backgroundColor = color
        navigationItem.backButtonTitle = ^String.Common.backTitle
    }
    
    func applyTransparentAppearance(color: UIColor = .appClear, tintColor: UIColor = .appBlack) {
        let appearance = UINavigationBarAppearance(transparent: true, color: color, tintColor: tintColor)
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }

    func pushViewController(_ controller: UIViewController, animated: Bool = true, hideTabBar: Bool = false) {
        controller.hidesBottomBarWhenPushed = hideTabBar
        navigationController?.pushViewController(controller, animated: animated)
    }
}
