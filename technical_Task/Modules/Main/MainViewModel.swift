//
//  MainViewModel.swift
//  technical_Task
//
//  Created by Daniil on 11.09.2023.
//

import Foundation
import UIKit
import Combine
import MapKit

class MainViewModel {
    
    enum Input {
        case viewDidLoad
    }
    
    enum Output {
        case setSections(titles: [String])
        case updateMapSection(_ coordinates: Coordinates, city: String)
        case updateWeatherSection(_ weather: Weather)
        case updateCoinsSection(_ coins: [Coin])
    }
    
    let settingsManager = SettingPreferenceManager()
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private(set) var sectionViews: [String.SectionsName : UIView] = [:]
    private let apiServices = ApiServices()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] value in
            guard let self = self else {
                return
            }
            switch value {
            case .viewDidLoad:
                self.getMapData()
                self.getCoins()
                self.getWeatherData()
                self.output.send(.setSections(titles: self.settingsManager.sectionsOrder))
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func getMapData() {
        guard let city = settingsManager.city?.title else {
            return
        }
        apiServices.getCityCoordinates(city).sink { [weak self] completion in
            self?.handleError(completion)
        } receiveValue: { [weak self] coordinatesObject in
            guard let coordinates = coordinatesObject.first else {
                return
            }
            self?.output.send(.updateMapSection(coordinates, city: city))
        }.store(in: &cancellables)
    }
    
    private func getWeatherData() {
        guard let city = settingsManager.city?.title else {
            return
        }
        apiServices.getCityCoordinates(city).sink { [weak self] completion in
            self?.handleError(completion)
        } receiveValue: { [weak self] coordinatesObject in
            guard let coordinates = coordinatesObject.first else {
                return
            }
            self?.handleWeatherCoordinates(coordinates)
        }.store(in: &cancellables)
    }
    
    private func handleWeatherCoordinates(_ coordinates: Coordinates) {
        apiServices.getWeather(coordinates: coordinates).sink { [weak self] completion in
            self?.handleError(completion)
        } receiveValue: { [weak self] weather in
            self?.output.send(.updateWeatherSection(weather))
        }.store(in: &cancellables)
    }
    
    private func getCoins() {
        guard let coins = settingsManager.coins?
            .map({ $0.id })
            .joined(separator: ", ") else {
            return
        }
        apiServices.getSelectedCoins(coins).sink { [weak self] completion in
            self?.handleError(completion)
        } receiveValue: { [weak self] coins in
            self?.output.send(.updateCoinsSection(coins))
        }.store(in: &cancellables)

    }
    
    private func handleError(_ completion: Subscribers.Completion<Error>) {
        guard case let .failure(error) = completion else {
            return
        }
        print(error.localizedDescription)
    }
}
