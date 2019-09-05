//
//  Util.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import AdSupport
import UIKit
import KeychainAccess

struct Util {
    
    /// 获取设备的版本号
    static func appVersion() -> String {
        let info = Bundle.main.infoDictionary
        let v = info?["CFBundleShortVersionString"] as? String
        return v ?? ""
    }
    
    /// 获取设备的IDFA
    static func appIDFA() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    /// 生成设备唯一标志字符串
    static func UUIDString() -> String {
        let chain = Keychain(service: "com.sensoro.app")
        if let str = try? chain.getString("com.sensoro.LXCamera") {
            return str
        }
        let udid = createDeviceUniqueIdentifier()
        try? chain.set(udid, key: "com.sensoro.LXCamera")
        let _ = chain.synchronizable(true)
        return udid
    }
    
    /// 生成设备唯一标志字符串
    private static func createDeviceUniqueIdentifier() -> String {
        let unique = CFUUIDCreate(kCFAllocatorDefault)
        let result = CFUUIDCreateString(kCFAllocatorDefault, unique)
        let res = String(describing: result)
        return res
    }
    
    ///RGB色值转换成16进制色值
    static func hexColorString(red r: CGFloat, green g: CGFloat, blue b: CGFloat) -> String {
        let hexSet =  ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
        let red = Int(r)
        let green = Int(g)
        let blue = Int(b)
        let rstr = hexSet[red/16] + hexSet[red%16]
        let gstr = hexSet[green/16] + hexSet[green%16]
        let bstr = hexSet[blue/16] + hexSet[blue%16]
        return "#" + rstr + gstr + bstr
    }
    
    
    
    
    
    
    
}
