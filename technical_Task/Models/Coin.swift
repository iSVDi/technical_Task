//
//  Coin.swift
//  technical_Task
//
//  Created by Daniil on 09.09.2023.
//

import Foundation

struct Coin: Codable {
    let id: String
    let name: String
    let imageUrl: URL
    let price: Double
    let priceChange: Double
    
    private enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "image"
        case price = "current_price"
        case priceChange = "price_change_24h"
    }
}

extension Coin: CommonItem {
    var commonId: String { return id }
    var title: String { return name }
    var countryShortName: String? { return nil }
    var urlImage: URL? { return imageUrl }
    
}
