//
//  UINavigationBarAppearance+Convenience.swift
//  technical_Task
//
//  Created by Daniil on 09.09.2023.
//

import UIKit

extension UINavigationBarAppearance {

    convenience init(transparent: Bool, color: UIColor, tintColor: UIColor) {
        self.init()
        if transparent {
            configureWithTransparentBackground()
        }
        backgroundColor = color
    titleTextAttributes = [.font: UIFont.sFProTextSemibold(ofSize: 17), .foregroundColor: tintColor]
        let button = UIBarButtonItemAppearance()
        [button.normal, button.highlighted].forEach {
            $0.titleTextAttributes = [.font: UIFont.sFProText(ofSize: 17), .foregroundColor: tintColor]
        }
        backButtonAppearance = button
    }

}
