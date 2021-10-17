//
//  ColorPalette.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 15/10/2021.
//

import Foundation
import UIKit

struct ColorPalette {
    static var background: UIColor = {
        return 0x123262.color
    }()

    static var black: UIColor = {
        return 0x000000.color
    }()

    static var gray: UIColor = {
        return 0x8D8D8D.color
    }()

    static var border: UIColor = {
        return 0xC4C4C4.color
    }()
}

private extension Int {
    var color: UIColor {
        let red = CGFloat((self & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((self & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat((self & 0x0000FF) >> 0) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
