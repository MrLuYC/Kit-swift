//
//  NSDateExtension.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/11.
//  Copyright © 2017年 Geek. All rights reserved.
//

import Foundation

extension NSDate{
    func isToDay() -> Bool
    {
        return  NSDate.dateStartOfDay(date: self).isEqual(to: NSDate.dateStartOfDay(date: NSDate.init()) as Date)
    }
    
    class func dateStartOfDay(date: NSDate) -> NSDate
    {
        let gregorian = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let componts = gregorian?.components([.year, .month, .day], from: date as Date)
        
        return (gregorian?.date(from: componts!))! as NSDate
    }
    
    class func isSameDayWithThime(firstTime: TimeInterval, secoundTime: TimeInterval) -> Bool
    {
        let firstDate = NSDate.init(timeIntervalSince1970: firstTime)
        let secondDate = NSDate.init(timeIntervalSince1970: secoundTime)
        
        return firstDate.isSameDayWithDate(date: secondDate)
    }
    
    class func isSameDatWithDate(firstDate: NSDate, secondDate: NSDate) -> Bool
    {
        let calendar = NSCalendar.current as NSCalendar
        
        let comp1 = calendar.components([.year, .month, .day], from: firstDate as Date)
        let comp2 = calendar.components([.year, .month, .day], from: secondDate as Date)
        
        return comp1.day == comp2.day && comp1.month == comp2.month && comp1.year == comp2.year
    }
    
    func isSameDayWithDate(date: NSDate) -> Bool
    {
        let calendar = NSCalendar.current as NSCalendar
        
        let comp1 = calendar.components([.year, .month, .day], from: self as Date)
        let comp2 = calendar.components([.year, .month, .day], from: date as Date)
        
        return comp1.day == comp2.day && comp1.month == comp2.month && comp1.year == comp2.year
    }
    
    class func acquireTimeFromDate(date: NSDate) -> NSDate
    {
        let calendar = NSCalendar.current as NSCalendar
        
        let comps = calendar.components([.year, .month, .day], from: date as Date)
        
        let result = calendar.date(from: comps)
        
        return result! as NSDate
    }
    
    class func acquireWeekDayFromDate(date: NSDate) -> Int
    {
        let calendar = NSCalendar.current as NSCalendar
        
        let comps = calendar.components(NSCalendar.Unit.weekday, from: date as Date)
        
        return comps.weekday!
    }
    
    func day() -> Int
    {
        let gregorian = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let components = gregorian?.components(NSCalendar.Unit.day, from: self as Date)
        
        return components!.day!
    }
    
    func month() -> Int
    {
        let gregorian = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let components = gregorian?.components(NSCalendar.Unit.month, from: self as Date)
        
        return components!.month!
    }
    
    func year() -> Int
    {
        let gregorian = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        let components = gregorian?.components(NSCalendar.Unit.year, from: self as Date)
        
        return components!.year!
    }
    
    /**
     从时间戳获取特定格式的时间字符串
     
     - parameter tt:     时间戳
     - parameter format: 格式
     
     - returns: 返回时间字符串
     */
    class func stringWithTimestamp(tt: TimeInterval, format: String) -> String
    {
        let date = NSDate.init(timeIntervalSince1970: tt)
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        
        return formatter.string(from: date as Date)
    }

}
