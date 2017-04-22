//
//  RotationButton.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/23.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

fileprivate let startDuration: TimeInterval = 0.3
fileprivate let endDuration: TimeInterval = 0.5

@objc protocol RotationButtonDelegate : NSObjectProtocol
{
    
    /// 动画开始回调
    ///
    /// - Parameter button: self
    @objc func rotationButtonDidStartAnimation(button: RotationButton)
    
    /// 动画结束时回调
    ///
    /// - Parameter button:  self
    @objc func rotationButtonDidFinishAnimation(button: RotationButton)
    
    /// 动画即将结束时的回调
    ///
    /// - Parameter button: <#button description#>
    @objc func rotationButtonWillFinishAnimation(button: RotationButton)
}

/// 旋转按钮
class RotationButton: UIButton
{
    var delegate: RotationButtonDelegate?
    
    lazy var circleView: CircleAnimationView? = {
        let circleView = CircleAnimationView(button: self)
        self.addSubview(circleView)
        
        return circleView
    }()
    
    var edgeColor: UIColor? {
        didSet{
            layer.borderColor = edgeColor?.cgColor
        }
    }
    
    var edgeWidth: CGFloat? {
        didSet{
            layer.borderWidth = edgeWidth!
        }
    }
    
    var isAnimation: Bool? {
        didSet{
            if (isAnimation)!{
                startAnimation()
            } else {
                stopAniamtion()
            }
        }
    }
    
    var origionRect: CGRect?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        layer.cornerRadius = frame.size.height / 2.0
        layer.masksToBounds = true
        clipsToBounds = false
        origionRect = self.frame
        
        addTarget(self, action: #selector(click(button:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        layer.cornerRadius = frame.size.height / 2.0
        layer.masksToBounds = true
        clipsToBounds = false
        origionRect = self.frame
        
        addTarget(self, action: #selector(click(button:)), for: .touchUpInside)
    }
}

fileprivate extension RotationButton
{
    func startAnimation()
    {
        let center = self.center
        let width = layer.cornerRadius * 2.0
        let height = frame.size.height
        let desFrame = CGRect(x: center.x - width / 2.0, y: center.y - height / 2.0, width: width, height: height)
        
        isUserInteractionEnabled = false

        delegate?.rotationButtonDidStartAnimation(button: self)
        self.titleLabel?.alpha = 0.0
        self.frame = desFrame
        UIView.animate(withDuration: startDuration, animations: {
        }) { (finished) in
            self.circleView?.startAnimation()
        }
    }
    
    func stopAniamtion()
    {
        
        delegate?.rotationButtonWillFinishAnimation(button: self)
        
        circleView?.removeFromSuperview()
        
        isUserInteractionEnabled = true
        circleView = nil
        
        UIView.animate(withDuration: endDuration, animations: { 
            self.frame = self.origionRect!
            self.titleLabel?.alpha = 1.0
        }) { (finished) in
            self.delegate?.rotationButtonDidFinishAnimation(button: self)
        }
        
    }
}

fileprivate extension RotationButton
{
    @objc func click(button: UIButton)
    {
        isAnimation = true
    }
}
