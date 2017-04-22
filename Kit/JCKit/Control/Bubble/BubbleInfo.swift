//
//  BubbleInfo.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/13.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit


/// 自定义动画闭包
typealias AnimationBlock = (_ layer: CAShapeLayer) -> Void

/// 进度被改变的闭包,通常用于自定义进度动画
typealias OnProgressChanged = (_ layer: CAShapeLayer, _ progress: CGFloat) -> Void

/// 图文布局样式
///
/// - style1: 图上文下
/// - style2: 图下文上
/// - style3: 图左文右
/// - style4: 图右文左
/// - iconOnlyStyle: 只显示图
/// - titleOnlyStyle: 只显示文字
public enum BubbleLayoutStyle: Int{
    case style1
    case style2
    case style3
    case style4
    case iconOnlyStyle
    case titleOnlyStyle
}


/// 位置样式
///
/// - top: 顶部
/// - center: 居中
/// - botton: 底部
public enum BubbleLocStyle: Int{
    case top
    case center
    case bottom
}

class BubbleInfo: NSObject{
    
    /// 泡泡控件大小
    public var bubbleSize: CGSize?
    
    /// 泡泡控件的圆角半径
    public var cornerRadius: CGFloat?
    
    /// 图文布局属性
    public var layoutStyle: BubbleLayoutStyle = BubbleLayoutStyle(rawValue: 0)!
    
    /// 图标动画
    public var iconAnimation: AnimationBlock?
    
    /// 进度被改变的回调
    public var onProgressChanged: OnProgressChanged?
    
    /// 图标数组，如果该数组为空或者该对象为nil，那么显示自定义动画，如果图标为一张，那么固定显示那个图标，大于一张的时候显示图片帧动画
    /// @brief 图标数组，如果该数组为空或者该对象为nil，那么显示自定义动画，如果图标为一张，那么固定显示那个图标，大于一张的时候显示图片帧动画
    open var iconArray: [UIImage]!
    
    /// @brief 要显示的标题
    open var title: String!
    
    /// @brief 帧动画时间间隔
    open var frameAnimationTime: CGFloat = 0.0
    
    /// @brief 图标占比 0 - 1，图标控件的边长占高度的比例
    open var proportionOfIcon: CGFloat = 0.0
    
    /// @brief 间距占比 0 - 1，图标控件和标题控件之间距离占整个控件的比例（如果横向布局那么就相当于宽度，纵向布局相当于高度）
    open var proportionOfSpace: CGFloat = 0.0
    
    /// @brief 内边距占比 0 - 1，整个泡泡控件的内边距，x最终为左右的内边距，y最终为上下的内边距（左右内边距以宽度算最终的像素值，上下边距以高度算最终的像素值）
    open var proportionOfPadding: CGPoint?
    
    /// @brief 位置样式
    open var locationStyle: BubbleLocStyle = BubbleLocStyle(rawValue: 0)!
    
    /// @brief 泡泡控件显示时偏移，当位置样式为上中的时候，偏移值是向下移动，当位置样式为底部时候，偏移值是向上移动
    open var proportionOfDeviation: CGFloat = 0.0
    
    /// @brief 是否展示蒙版，展示蒙版后，显示泡泡控件时会产生一个蒙版层来拦截所有其他控件的点击事件
    open var isShowMaskView: Bool = true
    
    /// @brief 蒙版颜色
    open var maskColor: UIColor!
    
    /// @brief 泡泡控件的背景色
    open var backgroundColor: UIColor!
    
    /// @brief 图标渲染色
    open var iconColor: UIColor!
    
    /// @brief 标题文字颜色
    open var titleColor: UIColor!
    
    /// @brief 标题字体大小
    open var titleFontSize: CGFloat = 0.0
    
    /// @breif key，随机数，用于标志一个info的唯一性，关闭时候会通过这个验证
    open var key: CGFloat = {
        return CGFloat(arc4random())
    }()
    
    override init()
    {
        super.init()
        
        self.bubbleSize = CGSize(width: 180.0, height: 120.0)
        self.cornerRadius = 8
        self.layoutStyle = .style1
        self.iconAnimation = nil
        self.onProgressChanged = nil
        self.title = "Bubble"
        self.frameAnimationTime = 0.1
        self.proportionOfIcon = 0.675
        self.proportionOfSpace = 0.1
        self.proportionOfPadding = CGPoint(x: 0.1, y: 0.1)
        self.locationStyle = .center
        self.proportionOfDeviation = 0
        self.isShowMaskView = true
        self.maskColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.iconColor = UIColor.white
        self.titleColor = UIColor.white
        self.titleFontSize = 13
    }
    
    convenience init(title: String, icon: UIImage)
    {
        self.init()
        
        self.title = title
        self.iconArray = [icon]
    }
    
    /**
     计算泡泡控件的整体frame
     
     @return 计算出的泡控件的frame
     */
    open func calBubbleViewFrame() -> CGRect
    {
        var y: CGFloat = 0
        
        switch (self.locationStyle){
            
        case .top:
            y = 0
            break
        case .center:
            y = (UIScreen.main.bounds.size.width - (self.bubbleSize?.height)!) / 2.0
            break
        case .bottom:
            y = UIScreen.main.bounds.size.height - (self.bubbleSize?.height)!
            break
        }
        
        y += (self.locationStyle != .bottom ? 1 : -1)
            * (self.proportionOfDeviation * UIScreen.main.bounds.size.height)
        
        return CGRect(x: (UIScreen.main.bounds.size.width - (self.bubbleSize?.width)!) / 2.0,
                      y: y,
                      width: (self.bubbleSize?.width)!,
                      height: (self.bubbleSize?.height)!)
    }
    
    /**
     计算并设置图标控件和标题控件的frame
     
     @param iconView 要设置的图标控件
     @param titleView 要设置的标题控件
     */
    open func calIconView(_ iconView: UIImageView!, andTitleView titleView: UILabel!)
    {

        let bubbleContentSize = CGSize(width: (self.bubbleSize?.width)! * (1.0 - (self.proportionOfPadding?.x)! * 2.0), height: (self.bubbleSize?.height)! * (1 - (self.proportionOfPadding?.y)! * 2.0))
        
        let iconWidth = (self.layoutStyle == .titleOnlyStyle) ? 0 : bubbleContentSize.height * self.proportionOfIcon
        
        let baseX = (self.bubbleSize?.width)! * (self.proportionOfPadding?.x)!
        let baseY = (self.bubbleSize?.height)! * (self.proportionOfPadding?.y)!
        
        //  计算文本高度,可能是单行页可能是多行
        //  线假设是单行文本
        let nsTtile = self.title as NSString
        let calTitleRect = nsTtile.size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: self.titleFontSize)])
        var titleWidth = (self.layoutStyle ==
            .style1 || self.layoutStyle ==
            .style2 || self.layoutStyle ==
            .titleOnlyStyle) ?
                bubbleContentSize.width : bubbleContentSize.width * ( 1
                    - self.proportionOfSpace) - iconWidth
    
        //  不能超过显示区域的宽度
        if ( titleWidth > calTitleRect.width) {
            titleWidth = calTitleRect.width
        }
        
        //  根据限定的宽度计算多行文本盖度
        let titleSize = self.measureStringSize(text: self.title, font: UIFont.systemFont(ofSize: titleFontSize), size: CGSize(width: titleWidth, height: CGFloat(MAXFLOAT)), lineBreakMode: NSLineBreakMode.byWordWrapping)
        var titleHeight = titleSize.height
        //  不能超过显示区域宽度
        if (titleHeight > bubbleContentSize.height){
            titleHeight = bubbleContentSize.height
        }
        
        //  初始化 frame
        var iconFrame = CGRect(x: baseY, y: baseY, width: iconWidth, height: iconWidth)
        var titleFrame = CGRect(x: baseX, y: baseY, width: titleWidth, height: titleHeight)
        switch (self.layoutStyle){
            
        case .style1:
            //  图标 + 文本高度
            let contentHeight = iconWidth + bubbleContentSize.height * self.proportionOfSpace + titleHeight
            //  垂直居中
            iconFrame.origin.x = baseX + (bubbleContentSize.width - iconWidth) / 2.0
            iconFrame.origin.y = baseY + (bubbleContentSize.height - contentHeight) / 2.0
            //  由图标 y 坐标求出文本 Y 坐标
            titleFrame.origin.y = iconFrame.origin.y + iconWidth + bubbleContentSize.height + self.proportionOfSpace
            titleFrame.origin.x = baseX + (bubbleContentSize.width - titleWidth) / 2.0
            break
            
        case .style2:
            //  图标 + 文本高度
            let contentHeight = iconWidth + bubbleContentSize.height * self.proportionOfSpace + titleHeight
            //  垂直居中，文本Y坐标
            titleFrame.origin.y = baseY + (bubbleContentSize.height - contentHeight) / 2.0
            titleFrame.origin.x = baseX + (bubbleContentSize.width - titleWidth) / 2.0
            //  由文本坐标求出图标坐标
            iconFrame.origin.x = baseX + (bubbleContentSize.width - iconWidth) / 2.0
            iconFrame.origin.y = titleFrame.origin.y + titleFrame.size.height + bubbleContentSize.height * self.proportionOfSpace
            break
            
        case .style3:
            let contenWidth = iconWidth + bubbleContentSize.width * self.proportionOfSpace + titleWidth
            //  水平居中，图标X坐标
            iconFrame.origin.x = baseX + (bubbleContentSize.width - contenWidth) / 2.0
            iconFrame.origin.y = baseY + (bubbleContentSize.height - iconWidth) / 2.0
            //  由图标X坐标求出文本X坐标
            titleFrame.origin.x = iconFrame.origin.x + iconWidth + bubbleContentSize.width * self.proportionOfSpace
            titleFrame.origin.y = baseY + (bubbleContentSize.height - titleHeight) / 2
            break
            
        case .style4:
            let contentWidth = iconWidth + bubbleContentSize.width * self.proportionOfSpace + titleWidth
            //水平居中，文本X坐标
            titleFrame.origin.x = baseX + (bubbleContentSize.width - contentWidth) / 2
            titleFrame.origin.y = baseY + (bubbleContentSize.height - titleHeight) / 2
            //由文本坐标求出图标坐标
            iconFrame.origin.x = titleFrame.origin.x + titleFrame.size.width + bubbleContentSize.width * self.proportionOfSpace
            iconFrame.origin.y = baseY + (bubbleContentSize.height - iconWidth) / 2
            break
            
        case .iconOnlyStyle:
            titleFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
            iconFrame.origin.x = baseX + (bubbleContentSize.width - iconWidth) / 2
            iconFrame.origin.y = baseY + (bubbleContentSize.height - iconWidth) / 2
            break
            
        case .titleOnlyStyle:
            titleFrame.origin.x = baseX + (bubbleContentSize.width - titleWidth) / 2
            titleFrame.origin.y = baseY + (bubbleContentSize.height - titleHeight) / 2
            iconFrame = CGRect(x: 0, y: 0, width: 0, height: 0)

            break
        }
        
        iconView.frame = iconFrame
        titleView.frame = titleFrame
    }
    
    
    /// 计算文本高度
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - font: 字体
    ///   - size: 大小
    ///   - lineBreakMode: 换行模式
    /// - Returns: 文本大小
    func measureStringSize(text: String,
                           font: UIFont,
                           size: CGSize,
                           lineBreakMode: NSLineBreakMode) -> CGSize
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode;
        let attributes = [NSFontAttributeName:font,
                          NSParagraphStyleAttributeName: paragraphStyle]
        let nsText = NSString(string: text)
        let tempSize = nsText.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).size
        
        return CGSize(width: CGFloat(ceilf(Float(tempSize.width))), height: CGFloat(ceilf(Float(tempSize.height))))
    }
}
