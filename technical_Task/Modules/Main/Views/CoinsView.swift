//
//  CoinsView.swift
//  technical_Task
//
//  Created by Daniil on 13.09.2023.
//

import UIKit
import TinyConstraints

class CoinsView: UIView {
    
    func setData(_ coins: [Coin]) {
        
        let widthMultiplier: CGFloat = {
            switch coins.count {
            case 1:
                return 1
            case 2:
                return 0.4
            case 3:
                return 0.3
            default:
                return 1
            }
        }()
        let coinsStackView = ViewsFactory.defaultStackView(spacing: 15, alignment: .fill)
        coins.forEach { coin in
            let view = coinViewBuilder(coin)
            coinsStackView.addArrangedSubview(view)
            view.widthToSuperview(multiplier: widthMultiplier)
            view.heightToSuperview(multiplier: 0.7)
            view.bottomToSuperview()
        }
        
        addSubview(coinsStackView)
        coinsStackView.edgesToSuperview(insets: .horizontal(20) + .bottom(10))
    }
    
    private func coinViewBuilder(_ coin: Coin) -> UIView {
        let stackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 2)
        let nameLabel = ViewsFactory.defaultLabel(alignment: .center)
        nameLabel.text = coin.name
        let coinImageView = ViewsFactory.defaultImageView()
        coinImageView.kf.setImage(with: coin.imageUrl)
        let priceLabel = ViewsFactory.defaultLabel(alignment: .center)
        priceLabel.text = coin.price.toString() + " $"
        let pricesChangesLabel = ViewsFactory.defaultLabel(alignment: .center)
        let priceUp = coin.priceChange >= 0
        let preffix = priceUp ? "" : "- "
        pricesChangesLabel.text = preffix + coin.priceChange.toString()
        pricesChangesLabel.textColor = priceUp ? UIColor.appSystemGreen : UIColor.appSystemRed
        
        [nameLabel, coinImageView, priceLabel, pricesChangesLabel].forEach { view in
            stackView.addArrangedSubview(view)
            view.horizontalToSuperview()
        }
        coinImageView.heightToSuperview(multiplier: 0.5)
        let wrapStack = stackView.wrap(horizontalInset: 2, verticalInset: 2)
        let wrappedStack = ViewsFactory.wrapView(wrapStack)
        return wrappedStack
    }
    
    
}
