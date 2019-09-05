//
//  UIScreenExtension.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

public extension UIScreen {
    static func currentWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width;
    }
    
    static func currentHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height;
    }
}
