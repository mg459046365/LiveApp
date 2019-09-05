//
//  UIColorExtension.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// 由16进制颜色值生成UIColor
    ///
    /// - Parameter rgb: 16进制色值，例如0xffffff
    /// - Parameter alpha: 透明度，默认为1.0
    convenience init(_ rgb: Int, _ alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(Float((rgb & 0xFF0000) >> 16) / 255.0),
                  green: CGFloat(Float((rgb & 0x00FF00) >> 8) / 255.0),
                  blue: CGFloat(Float(rgb & 0x0000FF) / 255.0), alpha: alpha)
    }
    
     func getClearTextColor() -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &alpha)
        let mean = r + g + b
        return mean > 2.3 ? .black : .white
    }
    
}
