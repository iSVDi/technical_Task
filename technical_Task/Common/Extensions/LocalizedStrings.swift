//
//  LocalizedStrings.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    enum Common: String {
        case backTitle
    }
    
    enum Alerts: String {
        case okTitle
        case errorTitle
    }
    
    
//    INFO: change carefully, it used in code
    enum SectionsName: String, CaseIterable {
        case city
        case weather
        case coins
    }
    
}

extension RawRepresentable {

    func format(_ args: CVarArg...) -> String {
        let format = ^self
        return String(format: format, arguments: args)
    }

}

prefix operator ^
prefix func ^ <Type: RawRepresentable>(_ value: Type) -> String {
    if let raw = value.rawValue as? String {
        let key = raw.capitalizeFirstLetter()
        return NSLocalizedString(key, comment: "")
    }
    return ""
}
