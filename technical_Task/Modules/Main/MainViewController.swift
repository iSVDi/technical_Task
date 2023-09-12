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
    
    private let sectionHeight: CGFloat = 300
    private let scrollView = ViewsFactory.defaultScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        applyDefaultSettings()
        setupNavigationBar()
        setupLayout()
        bind()
        input.send(.viewDidLoad)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case let .changeOrder(titles: titles):
                    self?.updateSections(titles: titles)
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
    
    private func updateSections(titles: [String]) {
        scrollView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        let views = titles.map { title in
            let label = ViewsFactory.defaultLabel()
            label.text = title
            label.textAlignment = .left
            
            let view = UIView()
            view.backgroundColor = .red
            
            let stack = ViewsFactory.defaultStackView(axis: .vertical, spacing: 5, alignment: .fill,  margins: .top(10))
            [label, view].forEach { view in
                stack.addArrangedSubview(view)
                view.horizontalToSuperview(insets: .horizontal(16))
            }
            view.bottomToSuperview()
            stack.height(sectionHeight)
            return stack
        }
        
        scrollView.stack(views, width: Constants.screenWidth)
        views.forEach { view in
            view.horizontalToSuperview()
        }
        
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
