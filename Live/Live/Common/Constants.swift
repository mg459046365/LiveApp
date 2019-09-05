//
//  Constants.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

enum FetchType {
    case idel
    case refresh
    case more
}

struct Constants {
    /// 屏幕宽度
    static let screenWidth: CGFloat = {
        min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }()

    /// 屏幕高度
    static let screenHeight: CGFloat = {
        max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }()

    /// 屏幕scale
    static let screenScale: CGFloat = {
        UIScreen.main.scale
    }()

    /// 状态栏高度
    static let statusBarHeight: CGFloat = {
        UIApplication.shared.statusBarFrame.height
    }()

    /// 状态栏 + 导航栏的高度
    static let statusNavHeight: CGFloat = {
        statusBarHeight + 44
    }()

    /// 分割线的高度
    static let lineHeight: CGFloat = {
        1.00 / screenScale
    }()

    /// 是否是X系列
    static let isiPhoneXSeries: Bool = {
        UIDevice().isiPhoneX
    }()

    /// 底部适配高度
    static let tabBarIndicatorHeight: CGFloat = {
        isiPhoneXSeries ? 34.0 : 0.0
    }()
}
