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
        case viewWillApper
    }

    enum Output {
        case changeOrder(titles: [String])
        case cityUpdated(_ key: String.SectionsName)
        case coinsUpdated(_ key: String.SectionsName)
    }
    
    private let settingsManager = SettingPreferenceManager()
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private(set) var sectionViews: [String.SectionsName : UIView] = [:]
    private let apiServices = ApiServices()
    
    init() {
        prepareSections()
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] value in
            guard let self = self else {
                return
            }
            switch value {
            case .viewWillApper:
                self.prepareMapView()
                self.prepareWeatherView()
                self.prepareCoinsView()
                self.output.send(.changeOrder(titles: self.settingsManager.sectionsOrder))
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func prepareSections() {
        let keys: [String.SectionsName] = {
            var res: [String.SectionsName] = []
            if settingsManager.city != nil {
                res.append(contentsOf: [.city, .weather])
            }
            if settingsManager.coins != nil {
                res.append(.coins)
            }
            return res
        }()
        
        keys.forEach { section in
            let view = SectionView()
            sectionViews[section] = view
        }
    }
    
    private func prepareMapView() {
        guard let city = settingsManager.city else {
            return
        }
        let map = sectionViews[String.SectionsName.city] as? MKMapView ?? MKMapView()
        
        apiServices.getCityCoordinates(city.title).sink { completion in
            guard case let .failure(error) = completion else {
                return
            }
            print(error.localizedDescription)
        } receiveValue: { [weak self] coordinatesArray in
            guard let self = self, let coordinate = coordinatesArray.first else {
                return
            }
            map.annotations.forEach { annotation in
                map.removeAnnotation(annotation)
            }
            let annotation = MKPointAnnotation()
            annotation.title = self.settingsManager.city?.title
            let clCoordniate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lon)
            annotation.coordinate = clCoordniate
            map.addAnnotation(annotation)
            let delta = 0.05
            let region = MKCoordinateRegion(center: clCoordniate, span: .init(latitudeDelta: delta, longitudeDelta: delta))
            map.setRegion(region, animated: true)
            map.isZoomEnabled = false
            map.isRotateEnabled = false
            map.isScrollEnabled = false
            self.sectionViews[String.SectionsName.city] = map
            self.output.send(.cityUpdated(.city))
        }.store(in: &cancellables)
    }
    
    private func prepareWeatherView() {
        guard let city = settingsManager.city else {
            return
        }
        
        apiServices.getCityCoordinates(city.title).sink { completion in
            guard case let .failure(error) = completion else {
                return
            }
            print(error.localizedDescription)
        } receiveValue: { [weak self] coordinatesAray in
            guard let coordinates = coordinatesAray.first else {
                return
            }
            self?.handleWeatherCoordinates(coordinates)
        }.store(in: &cancellables)
    }
    
    private func handleWeatherCoordinates(_ coordinates: Coordinates) {
        apiServices.getWeather(coordinates: coordinates).sink { completion in
            guard case let .failure(error) = completion else {
                return
            }
            print(error.localizedDescription)
        } receiveValue: { [weak self] weather in
            guard let self = self else {
                return
            }
            let weatherView = WeatherView()
            weatherView.setData(weather: weather)
            self.sectionViews[String.SectionsName.weather] = weatherView
            self.output.send(.cityUpdated(.weather))
        }.store(in: &cancellables)
    }
    
    private func prepareCoinsView() {
        guard let coins = settingsManager.coins, !coins.isEmpty else {
            return
        }
        
        let coinsTitle = coins.map({ $0.id}).joined(separator: ", ")
        apiServices.getSelectedCoins(coinsTitle).sink { completion in
            guard case let .failure(error) = completion else {
                return
            }
            print(error.localizedDescription)
        } receiveValue: { [weak self] coins in
            guard let self = self else {
                return
            }
            let coinsView = CoinsView()
            coinsView.setData(coins)
            self.sectionViews[String.SectionsName.coins] = coinsView
            self.output.send(.coinsUpdated(.coins))
        }.store(in: &cancellables)
    }
    
}
