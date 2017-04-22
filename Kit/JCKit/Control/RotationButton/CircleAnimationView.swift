//
//  CircleAnimationView.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/23.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

class CircleAnimationView: UIView
{
    var edgeColor: UIColor?
    var timeFlag: CGFloat?
    var timer: Timer?
    
    init(button: UIButton)
    {
        let frame = CGRect(x: -8,
                           y: -8,
                           width: button.frame.size.width + 16,
                           height: button.frame.size.height + 16)
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        edgeColor = button.titleLabel?.textColor
        timeFlag = 0
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview()
    {
        timer?.invalidate()
        super.removeFromSuperview()
    }
    
}

extension CircleAnimationView
{
    func startAnimation()
    {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(continueAnimation), userInfo: nil, repeats: true)
    }
    
    func continueAnimation()
    {
        timeFlag = timeFlag! + CGFloat(0.02)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect)
    {
        let path = UIBezierPath.init()
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        let radius = rect.size.width / 2.0 - 2.0
        let start = -CGFloat(M_PI_2) + timeFlag! * 2.0 * CGFloat(M_PI)
        let result1 = 0.45 * 2.0 * CGFloat(M_PI)
        let result2 = timeFlag! * 2.0 * CGFloat(M_PI)
        let end = -CGFloat(M_PI_2) + result1 + result2
        
        path.addArc(withCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        
        edgeColor?.setStroke()
        path.lineWidth = 1.5
        
        path.stroke()
    }
}
