//
//  Font.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation
import UIKit

extension UIFont {
    class func interBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Inter-Bold",
                      size: size)
    }

    class func interRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular",
                      size: size)
    }

    class func interMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: "Inter-Medium",
                      size: size)
    }
}
