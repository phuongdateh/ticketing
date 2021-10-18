//
//  UIViewExtentions.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation
import UIKit

extension UIView {
    func fitToSuperView(top: CGFloat = 0,
                    leading: CGFloat = 0,
                    trailing: CGFloat = 0,
                    bottom: CGFloat = 0) {
        guard let parentView = self.superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parentView.topAnchor,
                                      constant: top),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor,
                                         constant: bottom),
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor,
                                          constant: leading),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor,
                                           constant: trailing)
        ])
    }
}

extension CALayer {
    func applySketchShadow(color: UIColor,
                           alpha: Float = 1,
                           x: CGFloat = 0,
                           y: CGFloat = 8,
                           blur: CGFloat = 15,
                           spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func removeSketchShadow() {
        shadowOpacity = 0.0
    }
}
