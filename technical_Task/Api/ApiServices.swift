//
//  ApiServices.swift
//  technical_Task
//
//  Created by Daniil on 08.09.2023.
//

import Moya
import Combine

class ApiServices {
    
    private let provider = MoyaProvider<ApiRequestsTypes>()
    
    func getCityCoordinates(_ city: String ) -> AnyPublisher<[Coordinates], Error> {
        return handleArrayAnswer(target: .loadCityCoordinates(city))
    }
    
    func getWeather(coordinates: Coordinates) -> AnyPublisher<Weather, Error> {
        return provider.requestPublisher(.loadWeather(coordinates: coordinates))
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }.map({$0.data})
            .decode(type: Weather.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getCoins() -> AnyPublisher<[Coin], Error> {
        return handleArrayAnswer(target: .loadCoins)
    }
    
    func getSelectedCoins(_ coins: String) -> AnyPublisher<[Coin], Error> {
        return handleArrayAnswer(target: .loadSelectedCoins(coins))
    }
    
    private func handleArrayAnswer<T: Decodable>(target: ApiRequestsTypes) -> AnyPublisher<[T], Error> {
        return provider.requestPublisher(target)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }.map({$0.data})
            .decode(type: [T].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
