//
//  Weather.swift
//  technical_Task
//
//  Created by Daniil on 08.09.2023.
//

import Foundation

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

struct Weather: Codable {
    let city: String
    let details: [WeatherDetails]
    let indicators: WeatherIndicators
    let visibility: Double
    let wind: WeatherWind
    let clouds: WeatherClouds
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.details = try container.decode([WeatherDetails].self, forKey: .details)
        self.indicators = try container.decode(WeatherIndicators.self, forKey: .indicators)
        self.city = try container.decode(String.self, forKey: .city)
        self.visibility = Double(try container.decode(Int.self, forKey: .visibility)) / 1000
        self.wind = try container.decode(WeatherWind.self, forKey: .wind)
        self.clouds = try container.decode(WeatherClouds.self, forKey: .clouds)
    }
    
    private enum CodingKeys: String, CodingKey {
        case details = "weather"
        case indicators = "main"
        case city = "name"
        case visibility, wind, clouds
    }
}

struct WeatherDetails: Codable {
    let description: String
    let icon: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decode(String.self, forKey: .description)
        let iconName = try container.decode(String.self, forKey: .icon)
        self.icon = "https://openweathermap.org/img/wn/\(iconName).png"
    }
}

struct WeatherIndicators: Codable {
    let temperature: Double
    let feelLike: Double
    let pressure: Double
    let humidity: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temperature = try container.decode(Double.self, forKey: .temperature)
        self.feelLike = try container.decode(Double.self, forKey: .feelLike)
        self.pressure = Double(try container.decode(Double.self, forKey: .pressure)) * 0.750064
        self.humidity = try container.decode(Int.self, forKey: .humidity)
    }
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelLike = "feels_like"
        case pressure, humidity
    }
}

struct WeatherClouds: Codable {
    let indicator: Double
    
    private enum CodingKeys: String, CodingKey {
        case indicator = "all"
    }
}

struct WeatherWind: Codable {
    let speed: Double
    let deg: Double
}
