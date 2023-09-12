//
//  ChooseItemCell.swift
//  technical_Task
//
//  Created by Daniil on 12.09.2023.
//

import UIKit
import Kingfisher

class ChooseItemCell: UITableViewCell {

    private let label = ViewsFactory.defaultLabel()
    private let statusImageView = ViewsFactory.defaultImageView()
    
    private let leftLabel = ViewsFactory.defaultLabel(textColor: .appSystemGray)
    private let leftImageView = ViewsFactory.defaultImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        leftImageView.image = nil
        leftImageView.kf.cancelDownloadTask()
        statusImageView.image = nil
    }
    
    private func commonInit() {
        setupLayout()
    }
    
    private func setupLayout() {
        let leftStackView = ViewsFactory.defaultStackView()
        [leftImageView, leftLabel].forEach { view in
            leftStackView.addArrangedSubview(view)
            view.leftToSuperview()
            view.size(CGSize(width: 30, height: 30))
            view.isHidden = true
        }
        statusImageView.size(CGSize(width: 30, height: 30))
        let mainStackView = ViewsFactory.defaultStackView(alignment: .center)
        [leftStackView, label, statusImageView].forEach { view in
            mainStackView.addArrangedSubview(view)
        }
        label.setHugging(.defaultHigh, for: .horizontal)
        contentView.addSubview(mainStackView)
        mainStackView.edgesToSuperview(insets: .horizontal(16))
    }
    
    func setData(_ data: CommonItem, selected: Bool) {
        label.text = data.title
        if let url = data.urlImage {
            leftImageView.kf.setImage(with: url)
            leftImageView.isHidden = false
        } else if let leftTitle = data.countryShortName {
            leftLabel.text = leftTitle
            leftLabel.isHidden = false
        }
        
        statusImageView.image = selected ? AppImage.checkmark.uiImage : AppImage.plus.uiImage
    }
    
    
}
