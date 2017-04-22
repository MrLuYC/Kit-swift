//
//  HighLightButton.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/18.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

class HighLightButton: UIButton {

    var highlightedColor: UIColor?
    
    override var isHighlighted: Bool{
        didSet{
            if (isHighlighted){
                self.backgroundColor = self.highlightedColor
            } else {
                
                let delay = DispatchTime.now() + .seconds(Int(0.1 * CGFloat(NSEC_PER_SEC)))
                
                
                DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                    self.backgroundColor = nil
                })
            }
        }
    }

}
