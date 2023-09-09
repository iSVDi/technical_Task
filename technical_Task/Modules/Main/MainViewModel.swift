//
//  MainViewModel.swift
//  technical_Task
//
//  Created by Daniil on 08.09.2023.
//

import Moya
import Combine

class MainViewModel {
    
    private let provider = MoyaProvider<ApiRequestsTypes>()
    
    func getCityCoordinates(_ city: String ) -> AnyPublisher<[Coordinates], Error> {
        return arrayRequest(target: .loadCityCoordinates(city))
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
        return arrayRequest(target: .loadCoins)
    }
    
    func getSelectedCoins(_ coins: String) -> AnyPublisher<[Coin], Error> {
        return arrayRequest(target: .loadSelectedCoins(coins))
    }
    
    private func arrayRequest<T: Decodable>(target: ApiRequestsTypes) -> AnyPublisher<[T], Error> {
        return provider.requestPublisher(target)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }.map({$0.data})
            .decode(type: [T].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
