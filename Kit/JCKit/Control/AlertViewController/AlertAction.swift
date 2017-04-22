//
//  AlertAction.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/23.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

typealias AlertActionBack = (_ action: AlertAction) -> Void


/// alert 的按钮类型
///
/// - `default`: 默认的
/// - cancel: 取消的
/// - destructive: 毁灭的
public enum AlertActionStyle : Int
{
    case `default`
    case cancel
    case destructive
}

class AlertAction: NSObject
{
    private(set) var title: String?
    
    private(set) var actionHandler: AlertActionBack?
    
    private(set) var style: AlertActionStyle?
    
    init(title: String, style: AlertActionStyle, handler: AlertActionBack?)
    {
        super.init()
        self.title = title
        self.actionHandler = handler
        self.style = style
    }
    
}
