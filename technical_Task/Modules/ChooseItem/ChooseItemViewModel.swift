//
//  ChooseItemViewModel.swift
//  technical_Task
//
//  Created by Daniil on 12.09.2023.
//

import Foundation
import Combine


class ChooseItemViewModel {
    
    enum Input {
        case viewDidLoad
        case selectItem(_ item: CommonItem)
    }
    
    enum Output {
        case cities(_ cities: [City])
        case coins(_ coins: [Coin])
        case reloadTableView
    }
    
    private let mode: ChooseItemMode
    private let apiServices = ApiServices()
    private let settings = SettingPreferenceManager()
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    var city: String {
        return settings.city
    }
    
    var coins: [String] {
        return settings.coins
    }
    
    init(mode: ChooseItemMode) {
        self.mode = mode
    }
    
    func transform(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self = self else {
                return
            }
            
            switch input {
            case .viewDidLoad:
                self.handleViewDidLoad()
            case let .selectItem(item):
                self.selectItem(item)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func isItemSelected(_ item: CommonItem) -> Bool {
        switch mode {
        case .city:
            return settings.city == item.title
        case .coins(_):
            return settings.coins.contains(item.title)
        }
    }
    
    func selectItem(_ item: CommonItem) {
        switch mode {
        case .city:
            settings.city = item.title
        case let .coins(count):
            var coins = settings.coins
            if coins.count == count {
                coins.removeFirst()
            }
            coins.append(item.title)
            settings.coins = coins
        }
        output.send(.reloadTableView)
    }
    
    private func getCities() -> [City] {
        guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else { return [] }
        do {
            let data = try Data(contentsOf: url)
            let cities: [City] = try JSONDecoder().decode([City].self, from: data)
            return cities
        } catch {
            print(error)
            return []
        }
    }
    
    private func handleCoinsPresenting() {
        self.apiServices.getCoins().sink { completion in
            guard case let .failure(error) = completion else {
                return
            }
            print(error.localizedDescription)
        } receiveValue: { [weak self] coins in
            self?.output.send(.coins(coins))
        }.store(in: &self.cancellables)
    }
    
    private func handleViewDidLoad() {
        switch self.mode {
        case .city:
            self.output.send(.cities(self.getCities()))
        case .coins:
            self.handleCoinsPresenting()
        }
    }
   
}
