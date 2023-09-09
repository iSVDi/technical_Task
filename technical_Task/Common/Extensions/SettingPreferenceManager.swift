//
//  SettingPreferenceManager.swift
//  technical_Task
//
//  Created by Daniil on 09.09.2023.
//

import Foundation

enum SettingPreferenceManagerKeys: String {
    case sectionsOrder
}

class SettingPreferenceManager: PreferenceManager<SettingPreferenceManagerKeys> {
    
    override init() {
        super.init()
        register([SettingPreferenceManagerKeys.sectionsOrder.rawValue : ["Город", "Погода", "Курс криптовалют"]])
    }
    
    var sectionsOrder: [String] {
        get {
            return stringArray(for: .sectionsOrder)
        } set {
            setStringArray(newValue, for: .sectionsOrder)
        }
    }
}
