//
//  SegmentControl.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/23.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

let defaultWidth: CGFloat = 80.0
let defaultLineWidth: CGFloat = 2
let defaultColor = UIColor.gray
let defaultHighligColor = UIColor.red
let defaultTitleFont = UIFont.boldSystemFont(ofSize: 20.0)


let keyTitle = "title"
let keyTitleDetail = "titleDetail"
let keyImage = "image"

let itemSpacing = 30

/// 分段控制器样式
///
/// - filled: 充满屏幕宽度
/// - fit: 适应文字大小
/// - circle: 循环
public enum SegmentedControlStyle : Int
{
    case filled
    case fit
    case circle
}

/// 分段控制器协议
protocol SegmentedControlDelegate
{
    
    /// 选中分段控制器的的某项
    ///
    /// - Parameters:
    ///   - segmented: 分段控制器
    ///   - index:  选中的项
    ///   - animation: 动画效果
    func segmentedControlSelected(segmented: SegmentedControl, at index: Int, animation: Bool)
}

/// 属性声明
class SegmentedControl: UIView
{
    /// 分段控制器代理
    var delegate: SegmentedControlDelegate?
    
    /// 被选中项
    var selectedIndex: Int = 0
    
    /// 按钮标题集合
    var titles: Array<String>?
    
    /// 分段控制器样式
    var style: SegmentedControlStyle = .filled
    
    /// 背景图片
    var backgroundImage: UIImage?
    
    /// 底部高亮线 (lineWidth > 0)
    var lineWidth: CGFloat = 1.0
    
    /// 高亮颜色
    var highlighColor: UIColor?
    
    /// 边界线颜色
    var edgeColor: UIColor?
    
    /// 边界线的宽度
    var edgeWidth: CGFloat?
    
    /// 标题颜色
    var titleColor: UIColor?
    
    var titleFont: UIFont?
    
    fileprivate var lastSelectRect: CGRect = CGRect.zero
    
    fileprivate var items: Array<SegmentItem>?
    
    fileprivate(set) var scrollView: UIScrollView?
    
    fileprivate var lineLayer: CALayer?
    
    fileprivate var beginOffsetX: CFloat?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        initialize()
    }
}

// MARK: - system
extension SegmentedControl
{
    override func draw(_ rect: CGRect) {
        //  画高亮线
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setStrokeColor((edgeColor?.cgColor)!)
        context?.setLineWidth(edgeWidth!)
        context?.move(to: CGPoint(x: 0, y: rect.maxY - edgeWidth!))
        context?.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - edgeWidth!))
        context?.strokePath()
        
    }
    
    override func layoutSubviews() {
        let size = self.frame.size
        scrollView?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let item = items?.last
        
        scrollView?.contentSize = CGSize(width: (item?.frame.maxX)!, height: (scrollView?.frame.height)!)
    }
}

// MARK: - custom
extension SegmentedControl
{
    fileprivate func initialize()
    {
        //  初始化数据
        highlighColor = defaultHighligColor
        titleColor = defaultColor
        titleFont = defaultTitleFont
        lineWidth = defaultLineWidth
        backgroundColor = UIColor.clear
        
        items = Array<SegmentItem>()
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        scrollView?.autoresizesSubviews = false
        scrollView?.alwaysBounceHorizontal = true
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.scrollsToTop = false
        
        addSubview(self.scrollView!)
        
        //  初始化高亮线
        
        lineLayer = CALayer()
        lineLayer?.backgroundColor = highlighColor?.cgColor
        scrollView?.layer.addSublayer(lineLayer!)
    }
    
    /// 创建 items
    fileprivate func createItems(){
        if (self.titles == nil || self.titles?.count == 0) {
            return
        }
        
        var itemArray = Array<SegmentItem>()
        
        let screenWidth: CGFloat = self.w
        var itemWidth: CGFloat = 0.0
        let itemHeight: CGFloat = self.frame.height
        var itemRect: CGRect = CGRect.zero
        
        for i in 0 ..< (titles?.count)! {
            let title = titles?[i]
            
            if (style == .filled) {
                itemWidth = screenWidth / CGFloat((titles?.count)!)
                itemRect = CGRect(x: CGFloat(i) * itemWidth, y: 0, width: itemWidth, height: itemHeight)
            } else if (style == .fit) {
                itemWidth = SegmentItem.caculateWidth(title: title!, font: titleFont!)
                let lastItem = itemArray.last
                itemRect = CGRect(x: (lastItem?.frame.maxX)!, y: 0, width: itemWidth, height: itemHeight)
            }
            
            let item = createItem(rect: itemRect, title: title!)
            
            itemArray.append(item)
        }
        
        items = itemArray
    }
    
    fileprivate func createItem(rect: CGRect, title: String) -> SegmentItem {
        let item = SegmentItem(frame: rect)
        item.title = title
        item.titleColor = titleColor
        item.titleFont = titleFont
        item.highlightColor = highlighColor
        
        item.addTarget(self, action: #selector(segmentItemClicked(sender:)), for: .touchUpInside)
        
        scrollView?.addSubview(item)
        
        return item
    }
    
    func load()
    {
        //  初始化 scrollView
        if (backgroundImage != nil) {
            backgroundColor = UIColor(patternImage: backgroundImage!)
        }
        
        //  load 高亮线
        lineLayer?.backgroundColor = highlighColor as! CGColor?
        lineLayer?.frame = CGRect(x: (lineLayer?.frame.minX)!, y: self.frame.height - lineWidth, width: (lineLayer?.frame.width)!, height: lineWidth)
        
        //  初始化 ScrollView
        if (backgroundImage != nil) {
            backgroundColor = UIColor(patternImage: backgroundImage!)
        }
        
        for view in (scrollView?.subviews)! {
            view.removeFromSuperview()
        }
        
        createItems()
        
        //  根据 type初始化 items 
        self.selectedIndex = 0
        layoutSubviews()
    }
    
    //  滑动效果
    func scrollToRate(rate: CGFloat)
    {
        if (items == nil || items?.count == 0) {
            return
        }
        
        let currentItem = items?[selectedIndex]
        let previousItem = selectedIndex > 0 ? items?[selectedIndex - 1] : nil
        let nextItem = ( selectedIndex < (items?.count)! - 1) ? items?[selectedIndex + 1] : nil
        
        if fabs(Double(rate)) > 0.5 {
            if rate > 0.0 {
                if nextItem != nil {
                    segmentItemSelected(item: nextItem!)
                }
            } else if rate < 0.0 {
                if previousItem != nil {
                    segmentItemSelected(item: previousItem!)
                }
            }
        } else {
            if currentItem != nil {
                segmentItemSelected(item: currentItem!)
            }
        }
        
        var dx: CGFloat = 0.0
        var dw: CGFloat = 0.0
        
        if rate > 0.0 {
            if nextItem != nil {
                dx = (nextItem?.frame.minX)! - (currentItem?.frame.minX)!
                dw = (nextItem?.frame.width)! - (currentItem?.frame.width)!
            } else {
                dx = (currentItem?.frame.width)!
            }
        } else if rate < 0.0 {
            if previousItem != nil {
                dx = (currentItem?.frame.minX)! - (previousItem?.frame.minX)!
                
                dw = (currentItem?.frame.width)! - (previousItem?.frame.width)!
            } else {
                dx = (currentItem?.frame.width)!
            }
        }
        
        let x: CGFloat = lastSelectRect.minX + rate * dx
        let w = lastSelectRect.width + rate * dw
        lineLayer?.frame = CGRect(x: x, y: lastSelectRect.minY, width: w, height: lastSelectRect.height)
    }
    
     fileprivate func segmentItemSelected(item: SegmentItem) {
        
        for i in items! {
            i.isSelected = false
            i.refresh()
        }
        
        item.isSelected = true
        
    }
}

// MARK: - Events
extension SegmentedControl
{
    @objc fileprivate func segmentItemClicked(sender: UIButton) {
        
    }
}
