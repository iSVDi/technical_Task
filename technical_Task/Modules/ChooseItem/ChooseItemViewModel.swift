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
        case selectedItemsUpdate
    }
    
    private let mode: ChooseItemMode
    private let apiServices = ApiServices()
    private let settings = SettingPreferenceManager()
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    var selectedLabel: String {
        switch mode {
        case .city:
            return settings.city?.title ?? ""
        case .coins:
            return settings.coins?
                .map { $0.title }
                .joined(separator: " ") ?? ""
        }
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
            return settings.city?.id == item.commonId
        case .coins(_):
            guard let coins = settings.coins else {
                return false
            }
            return coins
                .map { $0.id }
                .contains(item.commonId)
        }
    }
    
    func selectItem(_ item: CommonItem) {
        switch mode {
        case .city:
            if let newCity = item as? City {
                settings.city = newCity
            }
        case let .coins(count):
            guard var coins = settings.coins,
                    let coin = item as? Coin,
                    !coins.contains(where: {$0.commonId == coin.commonId}) else {
                return
            }
            
            if coins.count == count {
                coins.removeFirst()
            }
            coins.append(coin)
            settings.coins = coins
        }
        output.send(.selectedItemsUpdate)
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
