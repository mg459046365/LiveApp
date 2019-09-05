//
//  UIViewExtension.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// 原点
    var by_origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            var rect = frame
            rect.origin = newValue
            frame = rect
        }
    }

    /// 视图左上角坐标x值
    var by_left: CGFloat {
        get {
            return frame.minX
        }
        set {
            var rect = frame
            rect.origin.x = newValue
            frame = rect
        }
    }

    /// 视图左上角坐标y值
    var by_top: CGFloat {
        get {
            return frame.minY
        }
        set {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
    }

    /// 视图右下角坐标x值
    var by_right: CGFloat {
        get {
            return frame.maxX
        }
        set {
            var rect = frame
            rect.origin.x = newValue - rect.width
            frame = rect
        }
    }

    /// 视图右下角坐标y值
    var by_bottom: CGFloat {
        get {
            return frame.maxY
        }
        set {
            var rect = frame
            rect.origin.y = newValue - rect.height
            frame = rect
        }
    }

    /// 视图中心点X值
    var by_centerX: CGFloat {
        get {
            return frame.midX
        }
        set {
            center = CGPoint(x: newValue, y: center.y)
        }
    }

    /// 视图中心点Y值
    var by_centerY: CGFloat {
        get {
            return frame.midY
        }
        set {
            center = CGPoint(x: center.x, y: newValue)
        }
    }

    /// 视图的size
    var by_size: CGSize {
        get {
            return frame.size
        }
        set {
            var rect = frame
            rect.size = newValue
            frame = rect
        }
    }

    /// 视图的宽度
    var by_width: CGFloat {
        get {
            return frame.width
        }
        set {
            var rect = frame
            rect.size.width = newValue
            frame = rect
        }
    }

    /// 视图的高度
    var by_height: CGFloat {
        get {
            return frame.height
        }
        set {
            var rect = frame
            rect.size.height = newValue
            frame = rect
        }
    }

    /// 视图设置边框
    func setBorder(edge: UIEdgeInsets, color: UIColor = UIColor(0xE5E5E5)) {
        if edge.top > 0 {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: by_width, height: edge.top)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }

        if edge.left > 0 {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: edge.left, height: by_height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }

        if edge.bottom > 0 {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: by_height - edge.bottom, width: by_width, height: edge.bottom)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }

        if edge.right > 0 {
            let layer = CALayer()
            layer.frame = CGRect(x: by_width - edge.right, y: 0, width: edge.right, height: by_height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
    }

    /// 移除所有子视图
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func snapshot() -> UIView {
        return snapshotView(afterScreenUpdates: true) ?? UIView()
//        if responds(to: #selector(snapshotView(afterScreenUpdates:))) {
//            return snapshotView(afterScreenUpdates: true) ?? UIView()
//        }
//        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
//        layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return UIImageView(image: image)
    }
    
    
}
