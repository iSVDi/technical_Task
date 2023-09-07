//
//  UIButton+Convenience.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import TinyConstraints

extension UIButton {

    func setupHorizontalInsets(image: CGFloat = 0, content: CGFloat = 0) {
        if semanticContentAttribute == .forceRightToLeft {
            let image = -image
            imageEdgeInsets = .right(image) + .left(-image)
            titleEdgeInsets = .left(image) + .right(-image)
        } else {
            imageEdgeInsets = .right(image) + .left(-image)
            titleEdgeInsets = .left(image) + .right(-image)
        }
        contentEdgeInsets = .horizontal(image + content)
    }

}

