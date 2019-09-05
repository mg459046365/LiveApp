//
//  BYDateFormater.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation

enum BYDateFormaterType: String, CustomStringConvertible {
    case type1 = "yyyy年M月d日"
    case type2 = "yyyy年MM月dd日"
    case type3 = "yyyy年MM月dd日 HH:mm:ss"
    case type4 = "yyyy年MM月dd日(ccc)"
    case type5 = "yyyy/MM/dd HH:mm:ss"
    case type6 = "yyyy/MM/dd"
    case type7 = "yyyy年MM月dd日(ccc) HH:mm:ss"
    case type8 = "yyyy年MM月"
    case type9 = "yyyy/MM"
    case type10 = "HH:mm:ss"
    case type11 = "yyyyMMddHHmmss"
    case type12 = "yyyy/MM/dd HH:mm"
    case type13 = "yyyyMMddHHmm"
    case type14 = "yyyy年MM月dd日(ccc)HH:mm"
    case type15 = "yyyyMMdd"
    case type16 = "HH:mm"
    case type17 = "HHmmss"
    case type18 = "HHmm"
    case type19 = "yyyy-MM-dd HH-mm-ss"
    case type20 = "HH"
    case type21 = "mm"
    case type22 = "ss"
    case type23 = "yyyy-MM-dd HH:mm"
    case type24 = "yyyy-MM-dd HH:mm:ss"
    case type25 = "yyyyMMddHHmmssSSSS"
    case type26 = "mm:ss"
    case type27 = "yyyy.MM.dd"
    case type28 = "yyyy.MM.dd HH:mm:ss"
    case type29 = "MM.dd"

    var description: String {
        return rawValue
    }
}

class BYDateFormater {
    let formatter = DateFormatter()

    static let shared = BYDateFormater()

    /// 初始化
    private init() {
        formatter.locale = Locale.current
    }

    /**
     将日期转换成字符串
     - parameter date: 日期
     - parameter type: 字符串格式
     - returns: 转换后的字符串
     */
    func convert(date: Date, type: BYDateFormaterType) -> String {
        formatter.dateFormat = type.rawValue

        return formatter.string(from: date)
    }

    /**
     将字符串转换成日期
     - parameter dateString: 字符串
     - parameter type: 日期格式
     - returns: Date 转换后的日期
     */
    func convert(dateString: String, type: BYDateFormaterType) -> Date {
        formatter.dateFormat = type.rawValue
        return formatter.date(from: dateString)!
    }

    /**
     将某种格式的日期字符串转换成另一种格式的日期字符串
     - parameter dateString: 日期字符串
     - parameter from: 被转换字符串格式
     - parameter to: 目的日期字符串的格式
     - returns: 转换后的字符串
     */
    func covert(dateString: String, from: BYDateFormaterType, to: BYDateFormaterType) -> String {
        let date = convert(dateString: dateString, type: from)
        let str = convert(date: date, type: to)
        return str
    }

    /**
     比较两个日期
     - parameter firstDate: 日期
     - parameter secondDate: 日期
     - returns: Tuples isSameYear-true同年，isSameMonth-true同月，isSameWeek-true同星期，sameDay-true同天
     */
    
    func compare(firstDate: Date, secondDate: Date) -> (isSameYear: Bool, isSameMonth: Bool, isSameWeek: Bool, isSameDay: Bool) {
        let calendar = Calendar.current

        let comp1 = calendar.dateComponents([.year, .month, .day], from: firstDate)
        let comp2 = calendar.dateComponents([.year, .month, .day], from: secondDate)

        let sameYear = (comp1.year == comp2.year)

        var sameMonth = false
        var sameWeek = false
        var sameDay = false

        if sameYear && comp1.month == comp2.month {
            sameMonth = true
        }

        if sameYear && sameMonth && comp1.weekOfMonth == comp2.weekOfMonth {
            sameWeek = true
        }

        if sameYear && sameMonth && comp1.day == comp2.day {
            sameDay = true
        }

        return (sameYear, sameMonth, sameWeek, sameDay)
    }

    ///以当前时间为参照为格式化日期字符串，如果给定日期如当前日期相差超过一个月，输出yyyy-MM-dd格式
    ///如果相差超过一天输出MM-dd格式
    ///如果是同一天则输出HH:mm
    /// - Parameter date: 时间
    /// - Returns: 时间字符串
    
    func formatDateSineNow(date: Date) -> String {
        let calendar = Calendar.current

        let comp1 = calendar.dateComponents([.year, .month, .day], from: date)
        let comp2 = calendar.dateComponents([.year, .month, .day], from: Date())

        formatter.dateFormat = BYDateFormaterType.type28.rawValue

        if comp1.year != comp2.year {
            return formatter.string(from: date)
        }

        if comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day {
            formatter.dateFormat = BYDateFormaterType.type10.rawValue
            return "今天 " + formatter.string(from: date)
        }

        let timeInterval = Date().timeIntervalSince(date)
        if timeInterval <= 60 * 60 * 24 {
            formatter.dateFormat = BYDateFormaterType.type10.rawValue
            return "昨天 " + formatter.string(from: date)
        }

        return formatter.string(from: date)
    }
}
