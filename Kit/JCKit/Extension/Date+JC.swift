//
//  DateExtension.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/11.
//  Copyright © 2017年 Geek. All rights reserved.
//

import Foundation

extension Date{
    
    /// 日期的开始时间
    ///
    /// - Parameter date: 日期
    /// - Returns: 返回日期
    static func dateStartOfDay(date: Date) -> Date
    {
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let componts = gregorian.dateComponents([.year, .month, .day], from: date)
        
        return (gregorian.date(from: componts))!
        
    }
    
    
    /// 判断是否同一天
    ///
    /// - Parameters:
    ///   - firstTime: 时间戳1
    ///   - secoundTime: 时间戳2
    /// - Returns: true 为同一天, false 不是同一天
    static func isSameDay(firstTime: TimeInterval, secondTime: TimeInterval) -> Bool
    {
        let firstDate = Date(timeIntervalSince1970: firstTime)
        let secondDate = Date(timeIntervalSince1970: secondTime)
        
        return firstDate.isSameDay(date: secondDate)
    }
    
    
    /// 判断是否同一天
    ///
    /// - Parameters:
    ///   - firstDate: 日期1
    ///   - secondDate: 日期2
    /// - Returns: true 为同一天, false 不是同一天
    static func isSameDay(firstDate: Date, secondDate: Date) -> Bool
    {
        let calendar = Calendar.current
        let comp1 = calendar.dateComponents([.year, .month, .day], from: firstDate)
        let comp2 = calendar.dateComponents([.year, .month, .day], from: secondDate)
        
        return comp1.day == comp2.day && comp1.month == comp2.month && comp1.day == comp2.day
    }
    
    /// 判断是否同一天
    ///
    /// - Parameter date: 日期
    /// - Returns: true 为相同, false 为不相同
    func isSameDay(date: Date) -> Bool
    {
        let calendar = Calendar.current
        
        let comp1 = calendar.dateComponents([.year, .month, .day], from: date)
        let comp2 = calendar.dateComponents([.year, .month, .day], from: date)
        
        return comp1.day == comp2.day && comp1.month == comp2.month && comp1.day == comp2.day
    }
    
    /// 获得时间
    ///
    /// - Parameter date: 日期
    /// - Returns: 日期
    static func acquireTime(date: Date) -> Date
    {
        let calendar = Calendar.current
        
        let coms = calendar.dateComponents([.year, .month, .year], from: date)
        let result = calendar.date(from: coms)
        
        return result!
    }
    
    
    /// 一周的天数
    ///
    /// - Parameter date: 日期
    /// - Returns: 返回天数
    static func acquirWeekDay(date: Date) -> Int
    {
        let calendar = Calendar.current
        
        let comps = calendar.dateComponents([.weekday], from: date)
        
        return comps.weekday!
    }
    
    /// 获取日期是几号
    ///
    /// - Returns:几号
    func day() -> Int
    {
        let gregoian = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = gregoian.dateComponents([.month], from: self)
        
        return components.day!
    }
    
    /// 获取日期月份
    ///
    /// - Returns: 几月份
    func month() -> Int
    {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = gregorian.dateComponents([.month], from: self)
        
        return components.month!
    }
    
    
    /// 获取日期年份
    ///
    /// - Returns: 年份
    func year() -> Int
    {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = gregorian.dateComponents([.year], from: self)
        
        return components.year!
    }
    
    
    /// 从时间戳获取指定格式的时间字符串
    ///
    /// - Parameters:
    ///   - tt: 时间戳
    ///   - format: 格式
    /// - Returns: 时间字符串
    static func dateString(tt: TimeInterval, format: String) -> String
    {
        let date = Date(timeIntervalSince1970: tt)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
}
