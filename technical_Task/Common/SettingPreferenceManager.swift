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
    
    var city: City? {
        get {
            guard let data = object(for: .selectedCity) as? Data else {
                return nil
            }
            return try? JSONDecoder().decode(City.self, from: data)
        } set {
            guard let city = newValue,
                    let data = try? JSONEncoder().encode(city) else {
                return
            }
            setObject(data, for: .selectedCity)
        }
    }
    
    var coins: [Coin]? {
        get {
            guard let data = object(for: .selectedCoins) as? Data else {
                return nil
            }
            return try? JSONDecoder().decode([Coin].self, from: data)
        } set {
            guard let coins = newValue,
                    let data = try? JSONEncoder().encode(coins) else {
                return
            }
            setObject(data, for: .selectedCoins)
        }
    }
    
}
