//
//  ChooseItemViewController.swift
//  technical_Task
//
//  Created by Daniil on 11.09.2023.
//

import UIKit

enum ChooseItemMode {
    case city
    case coins
}

class ChooseItemViewController: UIViewController {

    private let viewModel = ChooseItemViewModel()
    private let mode: ChooseItemMode
    
    private let selectedItemsLabel = ViewsFactory.defaultLabel()
    private let tableView = ViewsFactory.defaultTableView()
    
    private init(_ mode: ChooseItemMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        view.backgroundColor = .red
    }

    
    // MARK: - Builder
     
    class func prepare(_ mode: ChooseItemMode) -> UIViewController {
        return ChooseItemViewController(mode)
    }

    // MARK: - Helpers
    
    private func commonInit() {
        setupLayout()
        setupViews()
    }
    
    private func setupLayout() {
        let stackView = ViewsFactory.defaultStackView(axis: .vertical)
        [selectedItemsLabel, tableView].forEach { view in
            stackView.addArrangedSubview(view)
            view.horizontalToSuperview()
        }
        view.addSubview(stackView)
        stackView.edgesToSuperview(usingSafeArea: true)
        tableView.bottomToSuperview()
    }
    
    private func setupViews() {
        // TODO: localize
        navigationItem.title = mode == .city ? "Выбрать город" : "Выбрать криптовалюты"
    }
}
