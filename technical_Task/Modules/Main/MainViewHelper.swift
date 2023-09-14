//
//  MainViewHelper.swift
//  technical_Task
//
//  Created by Daniil on 14.09.2023.
//

import UIKit
import MapKit
import Combine

class MainViewHelper {
    
    private weak var controller: MainViewController?
    private(set) var sectionSubviews: [String.SectionsName : UIView] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    init(_ controller: MainViewController) {
        self.controller = controller
//        prepareSections()
    }
    
//    private func prepareSections() {
//        String.SectionsName.allCases.forEach { section in
//            let view = UIView()
//            sectionSubviews[section] = view
//        }
//    }
    
    func prepareMapView(coordinate: Coordinates, city: String) {
        let map = sectionSubviews[String.SectionsName.city] as? MKMapView ?? MKMapView()
        map.annotations.forEach { annotation in
            map.removeAnnotation(annotation)
        }
        let annotation = MKPointAnnotation()
        annotation.title = city
        
        let clCoordniate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lon)
        annotation.coordinate = clCoordniate
        map.addAnnotation(annotation)
        
        let delta = 0.05
        let region = MKCoordinateRegion(center: clCoordniate, span: .init(latitudeDelta: delta, longitudeDelta: delta))
        map.setRegion(region, animated: true)
        map.isZoomEnabled = false
        map.isRotateEnabled = false
        map.isScrollEnabled = false
        sectionSubviews[String.SectionsName.city] = map
    }
    
    func prepareWeatherView(_ weather: Weather) {
        let weatherView = WeatherView()
        weatherView.setData(weather: weather)
        sectionSubviews[String.SectionsName.weather] = weatherView
    }
    
    func prepareCoinsView(_ coins: [Coin]) {
        let coinsView = CoinsView()
        coinsView.setData(coins)
        sectionSubviews[String.SectionsName.coins] = coinsView
    }
    
}

