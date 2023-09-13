//
//  WeatherView.swift
//  technical_Task
//
//  Created by Daniil on 13.09.2023.
//

import UIKit
import Kingfisher
import TinyConstraints

class WeatherView: UIView {
    
    private let cityLabel = ViewsFactory.defaultLabel()
    private let descriptionLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    
    private let weatherImageView = ViewsFactory.defaultImageView()
    private let temperatureValueLabel = ViewsFactory.defaultLabel()
    
    private let feelLikeLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    private let feelLikeValueLabel = ViewsFactory.defaultLabel(font: .sFProDisplaySemibold(ofSize: 10))
    
    private let windLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    private let windValueLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    
    private let pressureLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    private let pressureValueLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    
    private let humidityLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    private let humidityValueLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    
    private let cloudLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    private let cloudValueLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    
    private let visibilityLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    private let visibilityValueLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 10))
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //TODO: localize
    func setData(weather: Weather) {
        setupDefaultLabels()
        cityLabel.text = weather.city
        if let details = weather.details.first {
            descriptionLabel.text = details.description
            weatherImageView.kf.setImage(with: URL(string: details.icon))
        }
        
        let indicators = weather.indicators
        temperatureValueLabel.text = indicators.temperature.toString() + " C"
        feelLikeValueLabel.text = indicators.feelLike.toString() + " C"
        windValueLabel.text = weather.wind.speed.toString() + " м/с"
        pressureValueLabel.text = indicators.pressure.toString() + " м.р.ст."
        humidityValueLabel.text = String(indicators.humidity) + " %"
        cloudValueLabel.text = weather.clouds.indicator.toString() + " %"
        visibilityValueLabel.text = weather.visibility.toString() + "км"
    }
    
    private func setupLayout() {
        let mainStackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 2, alignment: .center)
        let detailsView = getDetailsView()
        [cityLabel, descriptionLabel, detailsView].forEach { view in
            mainStackView.addArrangedSubview(view)
            view.horizontalToSuperview(insets: .left(10))
        }
        
        cityLabel.heightToSuperview(multiplier: 0.25)
        descriptionLabel.heightToSuperview(multiplier: 0.15)
        
        addSubview(mainStackView)
        mainStackView.edgesToSuperview()
    }
    
    private func setupDefaultLabels() {
        feelLikeLabel.text = "Ощущается как"
        windLabel.text = "Ветер"
        pressureLabel.text = "Давление"
        humidityLabel.text = "Влажность"
        cloudLabel.text = "Облачность"
        visibilityLabel.text = "Видимость"
    }
    
    private func getDetailsView() -> UIView {
        let temperatureView = getTemperatureView()
        let indicatorsView = getIndicatorsView()
        let descriptionStack = ViewsFactory.defaultStackView(spacing: 2)
        [temperatureView, indicatorsView].forEach { view in
            descriptionStack.addArrangedSubview(view)
            view.verticalToSuperview()
            view.widthToSuperview(multiplier: 0.5)
        }
        return descriptionStack
    }
    
    private func getTemperatureView() -> UIView {
        let temperatureStackView = ViewsFactory.defaultStackView(spacing: 2)
        [weatherImageView, temperatureValueLabel].forEach { view in
            temperatureStackView.addArrangedSubview(view)
            view.verticalToSuperview()
            view.widthToSuperview(multiplier: 0.5)
        }
        
        let feelLikeStackView = ViewsFactory.defaultStackView(spacing: 5)
        [feelLikeLabel, feelLikeValueLabel].forEach { view in
            feelLikeStackView.addArrangedSubview(view)
            view.verticalToSuperview()
            view.widthToSuperview(multiplier: 0.5)
        }
        
        let mainStackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 5)
        [temperatureStackView, feelLikeStackView].forEach { view in
            mainStackView.addArrangedSubview(view)
            view.horizontalToSuperview()
        }
        temperatureStackView.heightToSuperview(multiplier: 0.7)
        return mainStackView
    }
    
    private func getIndicatorsView() -> UIView {
        let indicatorPairs = [
            (windLabel, windValueLabel),
            (pressureLabel, pressureValueLabel),
            (humidityLabel, humidityValueLabel),
            (cloudLabel, cloudValueLabel),
            (visibilityLabel, visibilityValueLabel)
        ]
        let indicatorLines = indicatorPairs.map { (titleView, valueView) in
            let stack = ViewsFactory.defaultStackView(spacing: 10, alignment: .leading, margins: .right(10))
            [titleView, valueView].forEach { label in
                stack.addArrangedSubview(label)
                label.verticalToSuperview()
            }
            return stack
        }
        let indicatorView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 5, alignment: .center)
        indicatorLines.forEach { line in
            indicatorView.addArrangedSubview(line)
            line.horizontalToSuperview()
        }
        return indicatorView
        
    }

}
