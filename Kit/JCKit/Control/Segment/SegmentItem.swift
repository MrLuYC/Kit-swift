//
//  SegmentItem.swift
//  Kit
//
//  Created by LuYaoChuan on 17/2/12.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

class SegmentItem: UIButton
{
    var title: String?
    var highlightColor: UIColor?
    var titleColor: UIColor?
    var titleFont: UIFont?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func caculateWidth(title: String, font: UIFont) -> CGFloat {
        return 0.0
    }
    
    func refresh() {
        
    }
}
