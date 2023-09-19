//
//  MainViewController.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import UIKit
import Combine
import MapKit
import TinyConstraints

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<MainViewModel.Input, Never> = .init()
    
    private let sectionHeight: CGFloat = Constants.screenHeight * 0.35
    private let scrollView = ViewsFactory.defaultScrollView()
    
    private var sectionsView: [SectionView] = []
    private var sectionSubviews: [String.SectionsName : UIView] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        input.send(.viewDidLoad)
    }
    
    func updateSectionWithKey(_ key: String.SectionsName) {
        let section = scrollView.subviews.compactMap { view in
            return view as? SectionView
        }.first { section in
            section.titleKey == key
        }
        if let view = sectionSubviews[key] {
            section?.setData(titleKey: key, subview: view)
            section?.turnLoadingState(false)
        }
    }
    
    // MARK: - Helpers
    
    private func commonInit() {
        applyDefaultSettings(withBackgroundColor: .appSystemGray3)
        setupNavigationBar()
        setupLayout()
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case let .setSections(titles: titles):
                    self?.updateSections(titles: titles)
                case let .updateMapSection(coordinates, city):
                    self?.prepareMapView(coordinate: coordinates, city: city)
                    self?.updateSectionWithKey(.city)
                case let .updateWeatherSection(weather):
                    self?.prepareWeatherView(weather)
                    self?.updateSectionWithKey(.weather)
                case let .updateCoinsSection(coins):
                    self?.prepareCoinsView(coins)
                    self?.updateSectionWithKey(.coins)
                case let .startLoadingAnimation(section):
                    self?.startLoadingAnimation(section: section)
                }
            }.store(in: &cancellables)
    }
    
    private func setupNavigationBar() {
        let label = ViewsFactory.defaultLabel(textColor: .appWhite)
        //TODO: localize
        label.text = "Главный экран"
        let leftBarButton = UIBarButtonItem(customView: label)
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        
        let rightBarButton = UIBarButtonItem(image: AppImage.settings.uiImageWith(tint: .appWhite), style: .plain, target: self, action: #selector(rightBarButtonHandler))
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        applyTransparentAppearance(color: .appSystemBlue)
        
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.edgesToSuperview(usingSafeArea: true)
    }
    
    private func updateSections(titles: [String], needLoading: Bool = true) {
        let titleKeys = titles.compactMap { String.SectionsName.init(rawValue: $0) }
        
        let views = titleKeys.map { titleKey in
            let sectionView = SectionView()
            let sectionSubview = sectionSubviews[titleKey]
            sectionView.setData(titleKey: titleKey, subview: sectionSubview)
            
            if needLoading {
                startLoadingAnimation(section: titleKey)
            }
            
            let output = sectionView.bind()
            output.sink { [weak self] sectionName in
                switch sectionName {
                case .city, .weather:
                    self?.openChooseItem(.city)
                case .coins:
                    self?.openChooseItem(.coins(3))
                }
            }.store(in: &cancellables)
            return sectionView
        }
        sectionsView = views
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        scrollView.stack(views, width: Constants.screenWidth)
        views.forEach { view in
            view.horizontalToSuperview()
            view.height(sectionHeight)
        }
    }
    
    private func startLoadingAnimation(section: String.SectionsName) {
        guard let sectionView = sectionsView.first(where: {$0.titleKey == section}) else {
            return
        }
        sectionView.turnLoadingState(true)
    }
    
    private func openChooseItem(_ mode: ChooseItemMode) {
        let controller = ChooseItemViewController.prepare(mode)
        pushViewController(controller)
    }
    
    // MARK: - View Helpers
    
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
    
    // MARK: - Handlers
    
    @objc
    private func rightBarButtonHandler() {
        let settings = SettingsViewController()
        settings.transform().sink { [weak self] titles in
            self?.updateSections(titles: titles, needLoading: false)
        }.store(in: &cancellables)
        pushViewController(settings)
    }
    
}
