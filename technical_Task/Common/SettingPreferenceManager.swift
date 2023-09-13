//
//  SettingPreferenceManager.swift
//  technical_Task
//
//  Created by Daniil on 09.09.2023.
//

import Foundation

enum SettingPreferenceManagerKeys: String {
    case sectionsOrder
    case selectedCity
    case selectedCoins
}

class SettingPreferenceManager: PreferenceManager<SettingPreferenceManagerKeys> {
    
    override init() {
        super.init()
        let sections = String.SectionsName.allCases.map { $0.rawValue }
        register([SettingPreferenceManagerKeys.sectionsOrder.rawValue : sections])
    }
    
    var sectionsOrder: [String] {
        get {
            return stringArray(for: .sectionsOrder)
        } set {
            setStringArray(newValue, for: .sectionsOrder)
        }
    }
    
    var city: String {
        get {
            return string(for: .selectedCity)
        } set {
            setString(newValue, for: .selectedCity)
        }
    }
    
    var coins: [String] {
        get {
            return stringArray(for: .selectedCoins)
        } set {
            setStringArray(newValue, for: .selectedCoins)
        }
    }
    
}
