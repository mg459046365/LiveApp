//
//  StringExtension.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func formatSpaceAndNewlines() -> String {
        var content = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        content = content.replacingOccurrences(of: "\r", with: "")
        content = content.replacingOccurrences(of: "\n", with: "")
        return content
    }
    
    static func localString(_ key: String) -> String {
        return NSLocalizedString(key, comment: key)
    }
    
    func getSizeWithFont(_ font:UIFont, constrainedToSize size:CGSize) -> CGSize{
        if self.isEmpty == true { return CGSize.zero }
        let str = self as NSString
        let rect =  str.boundingRect(with: size, options: [NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue)
            ], attributes: [NSAttributedString.Key.font: font], context: nil)
        return rect.size
    }
    
}
