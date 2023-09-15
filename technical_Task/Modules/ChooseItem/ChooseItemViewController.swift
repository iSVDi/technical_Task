//
//  ChooseItemViewController.swift
//  technical_Task
//
//  Created by Daniil on 11.09.2023.
//

import UIKit
import Combine

enum ChooseItemMode: Equatable {
    case city
    case coins(Int)
}

protocol CommonItem {
    var commonId: String { get }
    var title: String { get }
    
    var countryShortName: String? { get }
    var urlImage: URL? { get }
}

class ChooseItemViewController: UIViewController {

    private lazy var viewModel = ChooseItemViewModel(mode: mode)
    private let mode: ChooseItemMode
    private var items: [CommonItem]
    private let input: PassthroughSubject<ChooseItemViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private let selectedItemsLabel = ViewsFactory.defaultLabel()
    private let tableView = ViewsFactory.defaultTableView()
    private let cellId = ChooseItemCell.description()
    
    
    private init(mode: ChooseItemMode) {
        self.mode = mode
        self.items = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultSettings()
        commonInit()
        bind()
        input.send(.viewDidLoad)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        input.send(.viewWillDisappear)
    }
    
    // MARK: - Builder
     
    class func prepare(_ mode: ChooseItemMode) -> UIViewController {
        return ChooseItemViewController(mode: mode)
    }

    private func bind() {
        let output = viewModel.transform(input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] output in
            switch output {
            case let .cities(cities):
                self?.items = cities
                self?.tableView.reloadData()
            case let .coins(coins):
                self?.items = coins
                self?.tableView.reloadData()
            case .selectedItemsUpdate:
                self?.reloadSelectedItems()
            }
        }.store(in: &cancellables)
    }
    
    // MARK: - Helpers
    
    private func commonInit() {
        setupLayout()
        setupViews()
    }
    
    private func setupLayout() {
        let stackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 5)
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
        selectedItemsLabel.text = viewModel.selectedLabel
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChooseItemCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func reloadSelectedItems() {
        selectedItemsLabel.text = viewModel.selectedLabel
        tableView.reloadData()
    }
    
}

extension ChooseItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ChooseItemCell
        let item = items[indexPath.row]
        cell?.setData(item, selected: viewModel.isItemSelected(item))
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        viewModel.selectItem(item)
    }
    
}
