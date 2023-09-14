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
    private let sectionSubview = UIView()
    private let selectButton = ViewsFactory.defaultButton()
    private let loadingIndicator = UIActivityIndicatorView()
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
    
    func turnLoadingState(_ state: Bool) {
        if state {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        
        selectButton.isHidden = loadingIndicator.isAnimating
        selectButton.superview?.isHidden = loadingIndicator.isAnimating
    }
    
    func setData(titleKey: String.SectionsName, subview: UIView?) {
        label.text = ^titleKey
        self.titleKey = titleKey
        
        guard let subview = subview else {
            setupSelectButton(true)
            return
        }
        sectionSubview.subviews.forEach {
            $0.removeFromSuperview()
        }
        sectionSubview.addSubview(subview)
        subview.layer.cornerRadius = 12
        subview.edgesToSuperview()
        setupSelectButton(false)
    }
    
    
    //MARK: - Helperts
    
    private func commonInit() {
        setupLayout()
        setupViews()
    }
    
    private func setupLayout() {
        [label, sectionSubview].forEach { view in
            stackView.addArrangedSubview(view)
            view.horizontalToSuperview(insets: .horizontal(16))
        }
        sectionSubview.heightToSuperview(multiplier: 0.8)
        addSubview(stackView)
        stackView.edgesToSuperview()
        addSubview(loadingIndicator)
        loadingIndicator.centerInSuperview()
    }
    
    private func setupViews() {
        label.textAlignment = .left
        sectionSubview.backgroundColor = .appSectionBackground
        sectionSubview.layer.cornerRadius = 12
        selectButton.addTarget(self, action: #selector(selectHandler), for: .touchUpInside)
    }
    
    private func setupSelectButton(_ firstSelect: Bool) {
        // TODO: localize
        if firstSelect {
            let wrappedButton = selectButton.wrap()
            sectionSubview.addSubview(wrappedButton)
            wrappedButton.layer.cornerRadius = 12
            wrappedButton.centerInSuperview()
            selectButton.setTitle("Выбрать", for: .normal)
            selectButton.backgroundColor = .appSystemBlue
            wrappedButton.backgroundColor = .appSystemBlue
        } else {
            selectButton.setImage(AppImage.settings.uiImageWith(tint: .appSystemBlue), for: .normal)
            sectionSubview.addSubview(selectButton)
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
