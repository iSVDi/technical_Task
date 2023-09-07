//
//  UIView+Convenience.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import TinyConstraints

extension UIView {

    func wrap(horizontalInset: CGFloat = 16, verticalInset: CGFloat = 9) -> UIView {
        let wrapView = UIView()
        wrapView.addSubview(self)
        edgesToSuperview(insets: .horizontal(horizontalInset) + .vertical(verticalInset))
        return wrapView
    }

    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }

}
