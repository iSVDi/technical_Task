//
//  WeatherView.swift
//  technical_Task
//
//  Created by Daniil on 13.09.2023.
//

import UIKit
import Kingfisher
import TinyConstraints

extension Double {
 
}

class WeatherView: UIView {
    
    private let cityLabel = ViewsFactory.defaultLabel(font: .sFProDisplaySemibold(ofSize: 30))
    private let descriptionLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 15))
    
    private let weatherImageView = ViewsFactory.defaultImageView()
    private let temperatureValueLabel = ViewsFactory.defaultLabel(font: .sFProDisplaySemibold(ofSize: 30), alignment: .center)
    
    private let feelLikeLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 15))
    private let feelLikeValueLabel = ViewsFactory.defaultLabel(font: .sFProDisplaySemibold(ofSize: 15), alignment: .center)
    
    private let windLabel = ViewsFactory.defaultLabel(font: .sFProDisplaySemibold(ofSize: 15))
    private let windValueLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 15))
    private let windDirectionImageView = ViewsFactory.defaultImageView(image: AppImage.systemDirection.uiImageWith(tint: .appBlack))
    
    private let pressureLabel = ViewsFactory.defaultLabel(font: .sFProDisplaySemibold(ofSize: 15))
    private let pressureValueLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 15))
    
    private let humidityLabel = ViewsFactory.defaultLabel(font: .sFProDisplaySemibold(ofSize: 15))
    private let humidityValueLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 15))
    
    private let cloudLabel = ViewsFactory.defaultLabel(font: .sFProDisplaySemibold(ofSize: 15))
    private let cloudValueLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 15))
    
    private let visibilityLabel = ViewsFactory.defaultLabel(font: .sFProDisplaySemibold(ofSize: 15))
    private let visibilityValueLabel = ViewsFactory.defaultLabel(font: .sFProText(ofSize: 15))
        
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
        let angle = weather.wind.deg.degreesToRadians
        windDirectionImageView.transform = windDirectionImageView.transform.rotated(by: CGFloat(angle))
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
            view.widthToSuperview(multiplier: 0.49)
        }
        return descriptionStack
    }
    
    private func getTemperatureView() -> UIView {
        let temperatureStackView = ViewsFactory.defaultStackView(spacing: 2)
        [weatherImageView, temperatureValueLabel].forEach { view in
            temperatureStackView.addArrangedSubview(view)
            view.verticalToSuperview()
        }
        temperatureValueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let feelLikeStackView = ViewsFactory.defaultStackView(spacing: 5)
        [feelLikeLabel, feelLikeValueLabel].forEach { view in
            feelLikeStackView.addArrangedSubview(view)
            view.verticalToSuperview()
        }
        feelLikeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
            (pressureLabel, pressureValueLabel),
            (humidityLabel, humidityValueLabel),
            (cloudLabel, cloudValueLabel),
            (visibilityLabel, visibilityValueLabel)
        ]
        
        var indicatorLines = indicatorPairs.map { (titleView, valueView) in
            let stack = ViewsFactory.defaultStackView(alignment: .leading, margins: .right(10))
            [titleView, valueView].forEach { label in
                stack.addArrangedSubview(label)
                label.verticalToSuperview()
                titleView.setContentHuggingPriority(.defaultHigh, for: .vertical)
            }
            return stack
        }
        let windStackView = ViewsFactory.defaultStackView(alignment: .leading, margins: .right(10))
        [windLabel, windValueLabel, windDirectionImageView].forEach { view in
            windStackView.addArrangedSubview(view)
            view.verticalToSuperview()
        }
        windStackView.setCustomSpacing(5, after: windValueLabel)
        indicatorLines.insert(windStackView, at: 0)
        
        let indicatorView = ViewsFactory.defaultStackView(axis: .vertical, alignment: .center)
        indicatorLines.forEach { line in
            indicatorView.addArrangedSubview(line)
            line.horizontalToSuperview()
            line.heightToSuperview(multiplier: 0.2)
        }
        return indicatorView
        
    }

}
