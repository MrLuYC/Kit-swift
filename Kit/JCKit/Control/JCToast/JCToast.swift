//
//  JCToast.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/12.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

/// toast 显示的位置类型
///
/// - top: 顶部
/// - center: 居中
/// - bottom: 底部
public enum JCToastShowType: Int {
    case top
    case center
    case bottom
    
}

let kDefaultForwardAnimationDuration:TimeInterval = 0.5
let kDefaultBackwardAnimationDuration: TimeInterval = 0.5
let kDefaultWaitAnimationDuration: TimeInterval = 1.0

let kDefaultTopMargin: CGFloat = 50.0
let kDefaultBottomMargin: CGFloat = 50.0
let kDefaultTextInst: CGFloat = 10.0


/// 消息提示控件
open class JCToast: UILabel, CAAnimationDelegate {
    
    /// 动画时间
    public var forwardAnimationDuration: TimeInterval = 0.0
    
    /// 动画时间
    public var backwardAnimationDuration: TimeInterval = 0.0
    
    /// 文本边距
    public var textInsets: UIEdgeInsets?
    
    /// 最大的宽度
    public var maxWidth: CGFloat = 0.0
    
    init(text: String)
    {
        super.init(frame: CGRect.zero)
        
        self.forwardAnimationDuration = kDefaultForwardAnimationDuration
        self.backwardAnimationDuration = kDefaultBackwardAnimationDuration
        self.textInsets = UIEdgeInsetsMake(kDefaultTextInst, kDefaultTextInst, kDefaultTextInst, kDefaultTextInst)
        self.maxWidth = UIScreen.main.bounds.width
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.numberOfLines = 0
        self.textAlignment = NSTextAlignment.left
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 14.0)
        
        self.text = text
        self.sizeToFit()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 显示在哪个 view 上
    ///
    /// - Parameter view: <#view description#>
    public func show(in view: UIView)
    {
        self.scaleAnimation()
        var point = view.center
        point.y = view.bounds.height - kDefaultBottomMargin
        self.center = point
        view.addSubview(self)
    }
    
    
    /// 显示消息
    ///
    /// - Parameters:
    ///   - view:  父视图
    ///   - type: 类型
    public func show(in view: UIView, type: JCToastShowType)
    {
        self.scaleAnimation()
        
        var point = view.center
        
        switch type {
        case .top:
            point.y = kDefaultTopMargin
            break
        case .bottom:
            point.y = view.bounds.height - kDefaultBottomMargin
            break
        default:
            break
        }
        
        self.center = point
        view.addSubview(self)
    }
    
    /// 显示信息
    ///
    /// - Parameter text: 信息
    public class func showMessage(text: String)
    {
        let window = UIApplication.shared.keyWindow
        
        let toast = JCToast(text: text)
        
        if (window == nil){
            return
        }
        
        toast.show(in: window!)
    }
    
    
    /// 在 view 上显示信息
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - view: 显示的位置类型
    public class func showMessage(text: String, in view: UIView)
    {
        let toast = JCToast(text: text)
        toast.show(in: view)
    }

    /// 显示信息
    ///
    /// - Parameters:
    ///   - text: 信息
    ///   - type: 显示的位置类型
    public class func showMessage(text: String, type: JCToastShowType)
    {
        let window = UIApplication.shared.keyWindow
        let toast = JCToast(text: text)
        
        if (window == nil){
            return
        }
        
        toast.show(in: window!, type: type)
    }
    
    
    /// 显示信息
    ///
    /// - Parameters:
    ///   - text:  信息
    ///   - view: 显示的 view
    ///   - type:  类型
    public class func showMessage(text: String, in view: UIView,
                                  type: JCToastShowType)
    {
        let toast = JCToast(text: text)
        toast.show(in: view, type: type)
    }
    
    /// 缩放动画
    private func scaleAnimation()
    {
        //  放大动画
        let forwardAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        forwardAnimation.duration = self.forwardAnimationDuration
        forwardAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 1.7, 0.6, 0.85)
        forwardAnimation.fromValue = NSNumber(value: 0.0)
        forwardAnimation.toValue = NSNumber(value: 1.0)
        
        //  缩小动画
        let backwardAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        backwardAnimation.duration = self.backwardAnimationDuration
        backwardAnimation.beginTime = forwardAnimation.duration
            + kDefaultWaitAnimationDuration
        backwardAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.15, 0.5, -0.7)
        backwardAnimation.fromValue = NSNumber(value: 1.0)
        backwardAnimation.toValue = NSNumber(value: 0.0)
        
        //  创建动画组
        let animationGroup: CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [forwardAnimation, backwardAnimation]
        animationGroup.duration = forwardAnimation.duration
            + backwardAnimation.duration + kDefaultWaitAnimationDuration
        animationGroup.isRemovedOnCompletion = false
        animationGroup.delegate = self
        animationGroup.fillMode = kCAFillModeForwards
        
        //  添加一组动画到 layer 里
        self.layer.add(animationGroup, forKey: nil)
        
    }
    
    ///  动画结束
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        if (flag){
            self.removeFromSuperview()
        }
    }
    
    
    /// 大小自适应
    open override func sizeToFit() {
        super.sizeToFit()
        
        var frame = self.frame
        let width = self.bounds.width + (self.textInsets?.left)!
            + (self.textInsets?.right)!
        frame.size.width = width > self.maxWidth ? self.maxWidth
            : width
        frame.size.height = self.bounds.height + (self.textInsets?.top)!
            + (self.textInsets?.bottom)!
        self.frame = frame
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, self.textInsets!))
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        let str = NSString(string: self.text!)
        
        var frame = bounds
        
        frame.size = str.boundingRect(with: CGSize(width:self.maxWidth - (self.textInsets?.left)! - (self.textInsets?.right)!, height:CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.font], context: nil).size
        
        return frame
    }
}
