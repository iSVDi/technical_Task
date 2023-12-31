//
//  Images.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import UIKit

enum AppImage: String {
    
    case leftChevron = "chevron.left"
    
    var uiImage: UIImage? {
        return UIImage(named: rawValue) ?? UIImage(systemName: rawValue)
    }

    func uiImageWith(font: UIFont? = nil, tint: UIColor? = nil) -> UIImage? {
        var img = uiImage
        if let font = font {
            img = img?.withConfiguration(UIImage.SymbolConfiguration(font: font))
        }
        if let tint = tint {
            return img?.withTintColor(tint, renderingMode: .alwaysOriginal)
        } else {
            return img
        }
    }
    
}
