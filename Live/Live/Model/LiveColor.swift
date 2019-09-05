//
//  LiveColor.swift
//  Live
//
//  Created by Beryter on 2019/8/27.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

struct LiveColor {
    private(set) var id: String = ""
    private(set) var r: CGFloat = 0
    private(set) var g: CGFloat = 0
    private(set) var b: CGFloat = 0
    private(set) var alpha: CGFloat = 1
    private(set) var name: String = ""
    private(set) var seriesName: String = ""
    
    
    init(id: String, r: CGFloat, g: CGFloat, b: CGFloat, name: String, seriesName: String) {
        self.id = id
        self.r = r
        self.g = g
        self.b = b
        self.name = name
        self.seriesName = seriesName
    }
    
    var color: UIColor {
        UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    var colorHexString: String {
        Util.hexColorString(red: r, green: g, blue: b)
    }
}
