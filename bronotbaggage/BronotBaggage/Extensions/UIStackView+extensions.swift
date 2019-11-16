//
//  UIStackView+extensions.swift
//  SmartIntercom
//
//  Created by andrewlupul on 23/07/2019.
//

import UIKit


extension UIStackView {
    func clear() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func set(views: [UIView]) {
        clear()
        views.forEach({ addArrangedSubview($0) })
        superview?.setNeedsLayout()
    }
}
