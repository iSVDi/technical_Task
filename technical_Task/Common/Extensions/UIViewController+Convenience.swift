//
//  UIViewController+Convenience.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import PKHUD
import SafariServices

extension UIViewController {

    func showHUD() {
        HUD.show(.progress)
    }

    func hideHUD() {
        HUD.hide()
    }

    func applyDefaultSettings(withBackgroundColor color: UIColor = .appBackground) {
        view.backgroundColor = color
        navigationItem.backButtonTitle = ^String.Common.backTitle
    }

    func pushViewController(_ controller: UIViewController, animated: Bool = true, hideTabBar: Bool = false) {
        controller.hidesBottomBarWhenPushed = hideTabBar
        navigationController?.pushViewController(controller, animated: animated)
    }
}
