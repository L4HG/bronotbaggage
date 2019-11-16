//
//  UIView+extensions.swift
//  SmartIntercom
//
//  Created by Кирилл Худяков on 03/04/2019.
//  Copyright © 2019 Сергей Ермолаев. All rights reserved.
//

import UIKit
import SnapKit




enum Corner: UInt {
    case topLeft = 1
    case topRight = 2
    case bottomLeft = 4
    case bottomRight = 8
    case top = 3
    case bottom = 12
}


extension UIView {
    func shadowApplied() {
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.masksToBounds = false
    }
    
    func dropCircleShadow(color: UIColor = .gray,
                          opacity: Float = 0.5,
                          offset: CGSize = CGSize(width: -1, height: 1),
                          radius: CGFloat = 10,
                          scale: Bool = true) {
        
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.masksToBounds = false
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = radius
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
    
    func setRounded(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setRounded(radius: CGFloat = 8) {
        layer.cornerRadius = radius
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.8
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, -3, 3, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}


extension UIView {
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        padding: UIEdgeInsets = .zero,
        size: CGSize = .zero
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if size.width > 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height > 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}


extension UIView {
    // Top Anchor
    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    // Bottom Anchor
    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    // Left Anchor
    var safeAreaLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        } else {
            return self.leftAnchor
        }
    }
    
    // Right Anchor
    var safeAreaRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        } else {
            return self.rightAnchor
        }
    }
    
    var safeArea: ConstraintLayoutGuideDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        
        return self.layoutMarginsGuide.snp
    }
}
