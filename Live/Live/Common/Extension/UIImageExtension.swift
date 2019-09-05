//
//  UIImageExtension.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 通过UIColor生成图片
    ///
    /// 当size等于CGSize.zero时，将返回一个nil对象。
    /// - Parameter color: 颜色
    /// - Parameter size: 图片的大小
    convenience init?(color: UIColor, size: CGSize) {
        guard size != .zero else {
            return nil
        }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let cgimage = context?.makeImage()
        UIGraphicsEndImageContext()
        self.init(cgImage: cgimage!)
    }
    
    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 通过UIColor异步生成图片
    ///
    /// 当size等于CGSize.zero时，将返回一个nil对象。
    /// - Parameter color: 色值
    /// - Parameter size: 图片的大小
    /// - Parameter completion: 异步回调
    class func asyncImage(withColor color: UIColor, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let image = UIImage(color: color, size: size)
            completion(image)
        }
    }
    
}
