//
//  SectionView.swift
//  technical_Task
//
//  Created by Daniil on 12.09.2023.
//

import UIKit
import Combine
import TinyConstraints

class SectionView: UIView {
    private let output: PassthroughSubject <String.SectionsName, Never> = .init()
    private let stackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 5, alignment: .center,  margins: .top(10))
    private let label = ViewsFactory.defaultLabel()
    private let subview = UIView()
    private let selectButton = ViewsFactory.defaultButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() -> AnyPublisher<String.SectionsName, Never> {
        return output.eraseToAnyPublisher()
    }
    
    func setData(title: String, view: UIView? = nil) {
        label.text = title
        
        setupSelectButton(view == nil)
        guard let view = view else {
            return
        }
        subview.addSubview(view)
        view.edgesToSuperview()
    }
    
    
    //MARK: - Helperts
    
    private func commonInit() {
        setupLayout()
        setupViews()
    }
    
    private func setupLayout() {
        [label, subview].forEach { view in
            stackView.addArrangedSubview(view)
            view.horizontalToSuperview(insets: .horizontal(16))
        }
        addSubview(stackView)
        stackView.edgesToSuperview()
        subview.bottomToSuperview()
        
    }
    
    private func setupViews() {
        label.textAlignment = .left
        subview.backgroundColor = .appSectionBackground
        subview.layer.cornerRadius = 12
        selectButton.addTarget(self, action: #selector(selectHandler), for: .touchUpInside)
    }
    
    private func setupSelectButton(_ firstSelect: Bool) {
        // TODO: localize
        if firstSelect {
            let wrappedButton = selectButton.wrap()
            subview.addSubview(wrappedButton)
            wrappedButton.layer.cornerRadius = 12
            wrappedButton.centerInSuperview()
            selectButton.setTitle("Выбрать", for: .normal)
            selectButton.backgroundColor = .appSystemBlue
            wrappedButton.backgroundColor = .appSystemBlue
        } else {
            selectButton.setImage(AppImage.settings.uiImageWith(tint: .appWhite), for: .normal)
            subview.addSubview(selectButton)
            let offset: CGFloat = 10
            selectButton.rightToSuperview(offset: offset)
            selectButton.topToSuperview(offset: offset)
        }
    }
    
    //MARK: - Handlers
    
    @objc
    private func selectHandler() {
        guard let title = label.text else {
            return
        }
        
        switch title {
        case ^String.SectionsName.city:
            output.send(.city)
        case ^String.SectionsName.weather:
            output.send(.weather)
        case ^String.SectionsName.coins:
            output.send(.coins)
        default:
            break
        }
    }
    
}
