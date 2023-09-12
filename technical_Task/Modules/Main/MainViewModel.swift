//
//  MainViewModel.swift
//  technical_Task
//
//  Created by Daniil on 11.09.2023.
//

import Foundation
import UIKit
import Combine

class MainViewModel {
    
    enum Input {
        case viewDidLoad
    }

    enum Output {
        case changeOrder(titles: [String])
    }
    
    private let model = MainModel()
    private let settingsManager = SettingPreferenceManager()
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] value in
            guard let self = self else {
                return
            }
            switch value {
            case .viewDidLoad:
                self.output.send(.changeOrder(titles: self.settingsManager.sectionsOrder))
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
}
