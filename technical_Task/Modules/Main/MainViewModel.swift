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
    }
    
    private let settingsManager = SettingPreferenceManager()
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private(set) var sectionViews: [String : UIView?] = [
        String.SectionsName.city.rawValue : MKMapView(), String.SectionsName.weather.rawValue : UIView(), String.SectionsName.coins.rawValue : UIView()
    ]
    private let apiServices = ApiServices()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] value in
            guard let self = self else {
                return
            }
            switch value {
            case .viewWillApper:
                self.prepareMapView()
                self.output.send(.changeOrder(titles: self.settingsManager.sectionsOrder))
                
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func prepareMapView() {
        guard !settingsManager.city.isEmpty else {
            sectionViews[String.SectionsName.city.rawValue] = nil
            return
        }
        let map = sectionViews[String.SectionsName.city.rawValue] as? MKMapView ?? MKMapView()
        
        apiServices.getCityCoordinates(settingsManager.city).sink { completion in
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
            annotation.title = self.settingsManager.city
            let clCoordniate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lon)
            annotation.coordinate = clCoordniate
            map.addAnnotation(annotation)
            let delta = 0.05
            let region = MKCoordinateRegion(center: clCoordniate, span: .init(latitudeDelta: delta, longitudeDelta: delta))
            map.setRegion(region, animated: true)
            map.isZoomEnabled = false
            map.isRotateEnabled = false
            map.isScrollEnabled = false
            self.sectionViews[String.SectionsName.city.rawValue] = map
            self.output.send(.changeOrder(titles: self.settingsManager.sectionsOrder))
        }.store(in: &cancellables)
    }
    
}
