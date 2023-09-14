//
//  MainViewController.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import UIKit
import Combine
import TinyConstraints

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<MainViewModel.Input, Never> = .init()
    
    private let sectionHeight: CGFloat = Constants.screenHeight * 0.35
    private let scrollView = ViewsFactory.defaultScrollView()
    private lazy var viewHelper = MainViewHelper(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        input.send(.viewDidLoad)
    }
    
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
                    self?.viewHelper.prepareMapView(coordinate: coordinates, city: city)
                    self?.updateSectionWithKey(.city)
                case let .updateWeatherSection(weather):
                    self?.viewHelper.prepareWeatherView(weather)
                    self?.updateSectionWithKey(.weather)
                case let .updateCoinsSection(coins):
                    self?.viewHelper.prepareCoinsView(coins)
                    self?.updateSectionWithKey(.coins)
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
    
    func updateSectionWithKey(_ key: String.SectionsName) {
        let section = scrollView.subviews.compactMap { view in
            return view as? SectionView
        }.first { section in
            section.titleKey == key
        }
        if let view = viewHelper.sectionSubviews[key] {
            section?.setData(titleKey: key, subview: view)
            section?.turnLoadingState(false)
        }
    }
    
    private func updateSections(titles: [String]) {
        let views = titles.map { title in
            let sectionView = SectionView()
            guard let titleKey = String.SectionsName.init(rawValue: title) else {
                return UIView()
            }
            let sectionSubview = viewHelper.sectionSubviews[titleKey]
            sectionView.setData(titleKey: titleKey, subview: sectionSubview)
            switch titleKey {
            case .city, .weather:
                sectionView.turnLoadingState(viewModel.settingsManager.city != nil)
            case .coins:
                sectionView.turnLoadingState(viewModel.settingsManager.coins != nil)
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
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        scrollView.stack(views, width: Constants.screenWidth)
        views.forEach { view in
            view.horizontalToSuperview()
            view.height(sectionHeight)
        }
    }
    
    private func openChooseItem(_ mode: ChooseItemMode) {
        let controller = ChooseItemViewController.prepare(mode, from: self)
        pushViewController(controller)
    }
    
    // MARK: - Handlers
    
    @objc
    private func rightBarButtonHandler() {
        let settings = SettingsViewController()
        settings.transform().sink { [weak self] titles in
            self?.updateSections(titles: titles)
        }.store(in: &cancellables)
        pushViewController(settings)
    }
    
}
