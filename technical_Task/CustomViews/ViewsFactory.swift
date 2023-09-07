//
//  ViewsFactory.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import TinyConstraints

class ViewsFactory {

    class func defaultButton(
        type: UIButton.ButtonType = .system,
        height: CGFloat? = nil,
        color: UIColor = .appSystemBlue,
        radius: CGFloat = 0,
        font: UIFont = .sFProDisplaySemibold(ofSize: 20),
        titleColor: UIColor = .appWhite
    ) -> UIButton {
        let button = UIButton(type: type)
        if let height = height {
            button.height(height)
        }
        button.backgroundColor = color
        button.layer.cornerRadius = radius
        button.titleLabel?.font = font
        button.setTitleColor(titleColor, for: .normal)
        return button
    }

    class func defaultLabel(
        lines: Int = 1,
        textColor: UIColor = .appBlack,
        font: UIFont = .sFProText(ofSize: 17),
        alignment: NSTextAlignment = .natural,
        adjustFont: Bool = false
    ) -> UILabel {
        let label = UILabel()
        label.numberOfLines = lines
        label.textColor = textColor
        label.font = font
        label.textAlignment = alignment
        if adjustFont {
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
        }
        return label
    }

    class func defaultImageView(
        contentMode: UIView.ContentMode = .scaleAspectFit,
        image: UIImage? = nil
    ) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = contentMode
        return imageView
    }

    class func defaultScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        return scrollView
    }

    class func defaultStackView(
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        margins: TinyEdgeInsets? = nil
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
        if let margins = margins {
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = margins
        }
        return stackView
    }

    class func separatorLine(color: UIColor, vertical: Bool = true, thickness: CGFloat = 1) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        if vertical {
            line.width(thickness)
        } else {
            line.height(thickness)
        }
        return line
    }

    class func defaultActivityIndicator(
        style: UIActivityIndicatorView.Style = .medium,
        color: UIColor = .appSystemGray
    ) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = color
        return indicator
    }

    class func defaultTextField(
        color: UIColor = .appWhite,
        font: UIFont = .sFProText(ofSize: 17),
        padding: CGFloat = 16,
        height: CGFloat = 60
    ) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = color
        textField.font = font

        let leftPadding = UIView()
        let rightPadding = UIView()
        [leftPadding, rightPadding].forEach { $0.frame.size = CGSize(width: padding, height: height) }
        textField.leftView = leftPadding
        textField.leftViewMode = .always
        textField.rightView = rightPadding
        textField.rightViewMode = .always
        textField.height(height)
        return textField
    }

    class func defaultTableView(style: UITableView.Style = .plain) -> UITableView {
        let tableView = UITableView(frame: .zero, style: style)
        tableView.backgroundColor = .appClear
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        return tableView
    }
    
    // MARK: - Custom Views
    
    class func backButton() -> UIButton {
        let button = defaultButton(
            color: .appClear,
            font: .sFProText(ofSize: 17),
            titleColor: .appSystemBlue
        )
        let image = AppImage.leftChevron.uiImageWith(font: .sFProTextSemibold(ofSize: 18))
        button.setImage(image, for: .normal)
        button.setupHorizontalInsets(image: 1)
        return button
    }

    class func wrapView(_ view: UIView) -> UIView {
        let wrapperView = UIView()
        wrapperView.backgroundColor = .appWhite
        wrapperView.layer.cornerRadius = 9
        wrapperView.clipsToBounds = true
        wrapperView.addSubview(view)
        view.edgesToSuperview()
        return wrapperView
    }

}

