//
//  ChooseItemViewModel.swift
//  technical_Task
//
//  Created by Daniil on 12.09.2023.
//

import Foundation

class ChooseItemViewModel {
    
    private func getCities() -> [City] {
        guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else { return [] }
        do {
            let data = try Data(contentsOf: url)
            let cities: [City] = try JSONDecoder().decode([City].self, from: data)
            return cities
        } catch {
            print(error)
            return []
        }
    }
    
}
