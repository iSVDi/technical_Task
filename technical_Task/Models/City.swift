//
//  City.swift
//  technical_Task
//
//  Created by Daniil on 12.09.2023.
//

import Foundation
import UIKit

struct City: Codable {
    
    let id: String
    let name: String
    let country: String
    
}

extension City: CommonItem {
    var title: String { return name }
    var countryShortName: String? { return country }
    var urlImage: URL? { return nil }
    
}
