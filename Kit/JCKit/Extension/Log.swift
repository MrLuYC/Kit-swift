//
//  Log.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/13.
//  Copyright © 2017年 Geek. All rights reserved.
//

import Foundation

extension NSDictionary{
    
    /// 获取类的信息
    ///
    /// - Returns: 类的信息
    func utf8description() -> String
    {
        var str = self.description as NSString
        str = NSString(cString: str.utf8String!, encoding: String.Encoding.nonLossyASCII.rawValue)!
        return String(str)
    }
}

extension NSArray{
    
    /// 获取类的信息
    ///
    /// - Returns: 返回类的信息
    func utf8description() -> String
    {
        var str = self.description as NSString
        str = NSString(cString: str.utf8String!, encoding: String.Encoding.nonLossyASCII.rawValue)!
        
        return String(str)
    }
}
