//
//  JC.swift
//  Kit
//
//  Created by LuYaoChuan on 17/2/27.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

extension UIFont
{
    class open func fontWithSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: UIView.widthFromIphone(size: size))
    }
    
    class open func boldFontWithSize(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: UIView.widthFromIphone(size: size))
    }
}
