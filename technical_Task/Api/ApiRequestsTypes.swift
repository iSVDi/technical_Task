//
//  Api.swift
//  technical_Task
//
//  Created by Daniil on 08.09.2023.
//

import Moya

enum ApiRequestsTypes {
    private static let apiKey = "52a37049e1b9b458866d5538e7ebeeb1"
    case loadCityCoordinates(_ city: String)
    case loadWeather(coordinates: Coordinates)
    case loadCoins
    case loadSelectedCoins(_ coins: String)
}

extension ApiRequestsTypes: TargetType {
    
    var baseURL: URL {
        switch self {
        case .loadCityCoordinates, .loadWeather:
            return URL(string:"https://api.openweathermap.org")!
        case .loadCoins, .loadSelectedCoins:
            return URL(string:"https://api.coingecko.com")!
        }
    }
    
    var path: String {
        switch self {
        case .loadCityCoordinates:
            return "/geo/1.0/direct"
        case .loadWeather:
            return "/data/2.5/weather"
        case .loadCoins, .loadSelectedCoins:
            return "/api/v3/coins/markets"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .loadCityCoordinates(let city):
            return ["q": city, "appid": ApiRequestsTypes.apiKey]
        case .loadWeather(let coordinates):
            return ["lat":"\(coordinates.lat)", "lon":"\(coordinates.lon)", "appid":"\(ApiRequestsTypes.apiKey)", "lang":"ru", "units": "metric"]
        case .loadCoins:
            return ["vs_currency": "usd", "per_page": 10, "price_change_percentage": "1h"]
        case .loadSelectedCoins(let coins):
            return ["vs_currency": "usd", "ids": coins, "price_change_percentage": "1h"]
        }
    }
    
    var task: Moya.Task {
        return .requestParameters(parameters: parameters!, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
}
