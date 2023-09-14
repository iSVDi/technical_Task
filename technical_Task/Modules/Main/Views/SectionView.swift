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
    private let stackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 5, alignment: .fill,  margins: .top(10))
    private let label = ViewsFactory.defaultLabel()
    private let subview = UIView()
    private let selectButton = ViewsFactory.defaultButton()
    private(set) var titleKey: String.SectionsName?
    
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
    
    func setData(titleKey: String.SectionsName, view: UIView? = nil) {
        label.text = ^titleKey
        self.titleKey = titleKey
        
        
        guard let view = view else {
            setupSelectButton(view == nil)
            return
        }
        subview.subviews.forEach {
            $0.removeFromSuperview()
        }
        subview.addSubview(view)
        view.layer.cornerRadius = 12
        view.edgesToSuperview()
        setupSelectButton(false)
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
        subview.heightToSuperview(multiplier: 0.8)
        addSubview(stackView)
        stackView.edgesToSuperview()
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
            selectButton.setImage(AppImage.settings.uiImageWith(tint: .appSystemBlue), for: .normal)
            subview.addSubview(selectButton)
            let offset: CGFloat = 10
            selectButton.setTitle("", for: .normal)
            selectButton.backgroundColor = .appClear
            selectButton.rightToSuperview(offset: -offset)
            selectButton.topToSuperview(offset: offset)
        }
    }
    
    //MARK: - Handlers
    
    @objc
    private func selectHandler() {
        guard let titleKey = titleKey else {
            return
        }
        output.send(titleKey)
    }
    
}
