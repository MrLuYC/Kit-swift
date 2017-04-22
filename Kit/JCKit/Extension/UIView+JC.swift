//
//  UIViewExtension.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/10.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

fileprivate let targetWPx: CGFloat = 414.0
fileprivate let targetHPx: CGFloat = 736.0

// MARK: - 扩展 UIView
extension UIView{
    
    /// view 的 x 位置
    var x: CGFloat {
        set (newValue) {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    /// view 的 y 位置
    var y: CGFloat {
        set (newValue) {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    /// view 的 width
    var w: CGFloat {
        set (newValue) {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    
    
    /// view 的 height
    var h: CGFloat {
        set (newValue) {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.size.height
        }
    }
    
    
    /// View 最大的 X 值
    var maxX: CGFloat {
        get {
            return self.x + self.w
        }
    }
    
    
    /// view 的最大的 Y 值
    var maxY: CGFloat {
        get {
            return self.y + self.w
        }
    }
    
    /// 是否切割边界
    var masksToBounds: Bool {
        set (newValue) {
            self.layer.masksToBounds = newValue
        }
        
        get {
            return self.layer.masksToBounds
        }
    }
    
    
    /// 弧形指数
    var cornerRadius: CGFloat {
        set (newValue) {
            self.layer.cornerRadius = newValue
        }
        
        get {
            return self.layer.cornerRadius
        }
    }
    
    
    /// 设置 view 的边框宽度
    var borderWidth: CGFloat {
        set (newValue) {
            self.layer.borderWidth = newValue
        }
        
        get {
            return self.layer.borderWidth
        }
    }
    
    
    /// 设置 view 的边框颜色
    var borderColor: UIColor {
        set (newValue) {
            self.layer.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    
    /// 获取相对于目标设备上的尺寸
    class open func widthFromIphone(size: CGFloat) -> CGFloat {
        #if TARGET_OS_IPHONE
            let width: CGFloat = 0.0
            if (width == 0.0) {
                width = UIScreen.main.bounds.size.width
            }
            return width / targetWPx * size
        #endif
        return size
    }
    /// 获取相对于目标设备上的尺寸
    class open func widthFromRealSize(size: CGFloat) -> CGFloat {
        #if TARGET_OS_IPHONE
            let width: CGFloat = 0.0
            if (width == 0.0) {
                width = UIScreen.main.bounds.size.width
            }
            return targetWPx / width * size
        #endif
        
        return size
    }
    /// 获取相对于目标设备上的尺寸
    class open func heightFromIphone(size: CGFloat) -> CGFloat{
        #if TARGET_OS_IPHONE
            let height: CGFloat = 0.0
            if (height == 0.0) {
                height = UIScreen.main.bounds.size.height
            }
            return height / targetHPx * size
        #endif
        return size
    }
    /// 获取相对于目标设备上的尺寸
    class open func heightFromRealSize(size: CGFloat) -> CGFloat {
        #if TARGET_OS_IPHONE
            let height: CGFloat = 0.0
            if (height == 0.0) {
                height = UIScreen.main.bounds.size.height
            }
            return targetHPx / height * size
        #endif
        return size
    }
}
