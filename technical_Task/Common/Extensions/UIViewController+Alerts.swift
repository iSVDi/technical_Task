//
//  UIViewController+Alerts.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import UIKit

extension UIViewController {

    func showAlertController(
        title: String?,
        message: String?,
        actions: [UIAlertAction],
        style: UIAlertController.Style = .alert
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }

    // MARK: - Alerts

    func showErrorAlert(title: String = ^String.Alerts.errorTitle, message: String?, completion: (() -> Void)? = nil) {
        let okAction = UIAlertAction(title: ^String.Alerts.okTitle, style: .cancel) { _ in completion?() }
        showAlertController(title: title, message: message, actions: [okAction])
    }
    
}

