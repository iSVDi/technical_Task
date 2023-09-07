//
//  Constants.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import UIKit

class Constants {

    static let screenWidth = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    static let screenHeight = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    
    static let bottomSafeArea: CGFloat = AppNavigator.shared.window.safeAreaInsets.bottom
    
    static let hasNotch = bottomSafeArea > 0
    static let statusBarHeight: CGFloat = hasNotch ? 44 : 20
    
}

