//
//  UIView+addSubviews.swift
//  TeslaApp
//
//  Created by Кирилл Худяков on 23/09/2019.
//

import UIKit


extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
