//
//  GridViewController.swift
//  Kit
//
//  Created by LuYaoChuan on 17/2/20.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

fileprivate let gridBtnImageSpacing: CGFloat = 10.0
fileprivate let gridBtnTitleMinHeight: CGFloat = 14.0
fileprivate let gridBtnPaddingMin: CGFloat = 8.0

/// 网格按钮的代理协议
protocol GridButtonDelegate: NSObjectProtocol {
    /// 响应格子的点击事件
    func gridItemDidClicked(clickItem: GridButton)
    /// 响应格子的长按手势事件
    func pressGestureStateBegan(longPressGesture: UILongPressGestureRecognizer, grid: GridButton)
    /// 响应格子移动事件
    func pressGestureStateChangeWith(gridPoint: CGPoint, gridItem: GridButton)
    /// 响应格子拖动结束事件
    func pressGestureStateStateEnded(gridItem: GridButton)
}

/// 网格按钮
class GridButton: UIButton
{
    //  v代理
    var delegate: GridButtonDelegate?
    //  是否圆形按钮
    var isimageISRound: Bool = false
    //  填充范围
    var padding: CGFloat = 0.0
    //  图片与位置的间距
    var imageTextSpace: CGFloat = 0.0
    //  图片最大尺寸
    var imageViewMaxSize: CGSize = CGSize.zero
    //  高亮背景颜色
    var backgroundHighligtedColor: UIColor?
    //  背景颜色
    var backgroundNormalColor: UIColor?
    //  格子选中的状态
    var isChecked: Bool = false
    //  格子点击状态
    var isClick: Bool = false
    //  格子的移动状态
    var isMove: Bool = false
    //  格子的排列索引位置
    var gridIndex: Int {
        set(newValue) {
            tag = newValue
        }
        get {
            return tag
        }
    }
    //  格子的位置坐标
    var gridCenterPoint: CGPoint = CGPoint.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        addAction()
    }
    
    init(frame: CGRect,
         title: String,
         iconImage: UIImage,
         normalImage: UIImage, highlightedImage: UIImage, gridID: Int)
    {
        super.init(frame: frame)
        addAction()
        setTitle(title, for: .normal)
        setImage(iconImage, for: .normal)
        setTitleColor(UIColor.black, for: .normal)
        setBackgroundImage(normalImage, for: .normal)
        setBackgroundImage(highlightedImage, for: .highlighted)
        gridIndex = gridID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    /// 重新设计布局
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        adjustsImageWhenHighlighted = false
        
        if (padding == 0.0) {
            padding = gridBtnPaddingMin
        }
        
        if (imageTextSpace == 0.0) {
            imageTextSpace = gridBtnImageSpacing
        }
        
        var titleLabelHeight: CGFloat = (titleLabel?.frame.size.height)!
        if (titleLabelHeight == 0.0) {
            titleLabelHeight = gridBtnTitleMinHeight
        }
        
        var imageMaxHeight = frame.size.height - titleLabelHeight - imageTextSpace - padding * 2.0
        var imageMaxWidth = frame.size.width - padding * 2.0
        
        if (imageViewMaxSize.height != 0.0) {
            imageMaxHeight = imageViewMaxSize.height
        }
        if (imageViewMaxSize.width != 0.0) {
            imageMaxWidth = imageViewMaxSize.width
        }
        
        if ((imageView?.frame.size.height)! > imageMaxHeight) {
            var newImageViewFrame = imageView?.frame
            newImageViewFrame?.size = CGSize(width: imageMaxHeight / (imageView?.frame.size.height)! * (imageView?.frame.size.width)! , height: imageMaxHeight)
            imageView?.frame = newImageViewFrame!
        }
        
        if ((imageView?.frame.size.width)! > imageMaxWidth) {
            var newImageViewFrame = imageView?.frame
            newImageViewFrame?.size = CGSize(width: imageMaxWidth, height: imageMaxWidth / (imageView?.frame.size.width)! * (imageView?.frame.size.height)!)
            imageView?.frame = newImageViewFrame!
        }
        
        let result = imageTextSpace + titleLabelHeight
        
        let totalHeight = (imageView?.frame.size.height)! + result
        
        var center: CGPoint = (imageView?.center)!
        center.x = frame.size.width / 2.0
        center.y = frame.size.height / 2.0 - totalHeight / 2.0 + (imageView?.frame.size.height)! / 2.0
        imageView?.center = center
        
        if (isimageISRound) {
            imageView?.layer.cornerRadius = (imageView?.frame.size.width)! / 2.0
        }
        
        var titleLabelFrame = titleLabel?.frame
        titleLabelFrame?.size = CGSize(width: frame.size.width, height: titleLabelHeight)
        titleLabel?.frame = titleLabelFrame!
        
        var titleCenter = titleLabel?.center
        titleCenter?.x = frame.size.width / 2.0
        let height1 = (imageView?.frame.size.height)! / 2.0
        let height2 = titleLabelHeight / 2.0
        titleCenter?.y = (imageView?.center.y)! + height1 +  imageTextSpace + height2
        titleLabel?.center = titleCenter!
        
        titleLabel?.textAlignment = .center
    }
}

// MARK: - 网格按钮扩展
extension GridButton
{
    func addAction()
    {
        addTarget(self,
                  action: #selector(gridClick(clickItem:)),
                  for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer.init(target: self,
                                                          action: #selector(gridLongPress(longPressGesture:)))
        addGestureRecognizer(longPress)
    }
    
    func gridClick(clickItem: GridButton)
    {
        delegate?.gridItemDidClicked(clickItem: clickItem)
    }
    
    func gridLongPress(longPressGesture: UILongPressGestureRecognizer)
    {
        switch (longPressGesture.state) {
        case .began:
            delegate?.pressGestureStateBegan(longPressGesture: longPressGesture,
                                             grid: self)
            break
            
        case .changed:
                let newPoint = longPressGesture.location(in: longPressGesture.view)
                self.delegate?.pressGestureStateChangeWith(gridPoint: newPoint, gridItem: self)
            break
            
        case .ended:
            delegate?.pressGestureStateStateEnded(gridItem: self)
            break
        default:
            break
        }
    }
    
    class func indexOf(point: CGPoint, with btn: GridButton, gridListArray: Array<GridButton>) -> Int
    {
        for i: Int in 0..<gridListArray.count {
            let appButton = gridListArray[i]
            if (appButton != btn) {
                if (appButton.frame.contains(point)) {
                    return i
                }
            }
        }
        
        return -1
    }
}

/// 网格视图控制器
class GridViewController: UIViewController
{

    var normalImage: UIImage?
    
    var highlightedImage: UIImage?
    
    var startPoint: CGPoint = CGPoint.zero
    
    var originPoint: CGPoint = CGPoint.zero
    var contain: Bool = false
    
    /// 网格按钮集合
    open lazy var gridBtns: Array<GridButton> = {
        let gridBtns = Array<GridButton>()
        return gridBtns;
    }()
    
    ///  懒加载网格按钮集合视图
    open lazy var gridListView: UIView = {
        let gridListView = UIView(frame: CGRect.zero)
        gridListView.backgroundColor = UIColor.white
        return gridListView
    }()
    
    /// 懒加载滚动视图
    open lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    
    /// 最大列数
    open var maxCol: Int = 0 {
        didSet {
            
        }
    }
    
    /// 最大的行数
    open var maxRol: Int = 0 {
        didSet{
           
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        scrollView.frame = view.frame
        gridListView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: 0)
        view.addSubview(scrollView)
        
    }
    
    /// 重新布局视图
    func layoutGridListView()
    {
        let gridBtns = self.gridBtns
        
        let count: Int = gridBtns.count
        
        let btnW = gridBtnW
        let btnH = gridBtnH
        
        //  重新计算每个网络视图的位置
        for index: Int in 0 ..< count {
            let col = index % maxCol
            let rol = index / maxCol
            
            let gridBtn = gridBtns[index]
            gridBtn.frame = CGRect(x: CGFloat(col) * btnW, y: CGFloat(rol) * btnH, width: btnW, height: btnH)
        }
        
        //  重新计算网格视图的宽度
        let gridBtn: UIButton? = gridBtns.last! as UIButton
        if (gridBtn != nil) {
            var gridListFrame = gridListView.frame
            gridListFrame.size.height = (gridBtn?.frame.maxY)!
            gridListView.frame = gridListFrame;
        } else {
            var gridListFrame = gridListView.frame
            gridListFrame.size.height = 0;
            gridListView.frame = gridListFrame
        }
    }
}

extension GridViewController
{
    /// 返回按钮宽度
    open var gridBtnW: CGFloat {
        return view.bounds.size.width / CGFloat(maxCol)
    }
    /// 返回按钮高度
    open var gridBtnH: CGFloat {
        return view.bounds.size.width / CGFloat(maxRol)
    }
    
    /// 添加网格视图
    func addGridBtn(gridBtn: GridButton)
    {
        let count = gridBtns.count
        
        //  计算网络按钮的位置和大小
        let col = count % maxCol
        let rol = count / maxCol
        
        let btnW = gridBtnW
        let btnH = gridBtnH
        
        gridBtn.frame = CGRect(x: CGFloat(col) * btnW,
                               y: CGFloat(rol) * btnH,
                               width: btnW,
                               height: btnH);
        
        gridListView.addSubview(gridBtn)
        gridBtns.append(gridBtn)
        
        var gridListViewFrame = gridListView.frame
        
        gridBtn.delegate = self
        gridBtn.gridCenterPoint = gridBtn.center
        
        gridListViewFrame.size.height = gridBtn.frame.maxY
        gridListView.frame = gridListViewFrame
        
        if (gridListViewFrame.size.height > view.frame.size.height) {
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        }
    }
    
    func sortGridList()
    {
        let gridBtns = self.gridBtns
        
        //  重新排列数组中存放的格子顺序
        _ = gridBtns.sorted { (obj1: Any, obj2: Any) -> Bool in
            let tempGrid1 = obj1 as! GridButton
            let tempGrid2 = obj2 as! GridButton
            
            return tempGrid1.gridIndex > tempGrid2.gridIndex
        }
        
        //  更新所有格子的中心点坐标信息
        for i: Int in 0..<gridBtns.count {
            let gridItem = gridBtns[i]
            gridItem.gridCenterPoint = gridItem.center
        }
    }
    
}

// MARK: - 按钮代理方法实现
extension GridViewController: GridButtonDelegate
{
    func gridItemDidClicked(clickItem: GridButton)
    {
        
    }
    
    func pressGestureStateBegan(longPressGesture: UILongPressGestureRecognizer, grid: GridButton)
    {
         // 判断格子是否已经被选中且是否可移动状态,如果选中就一个放大的特效
        if (grid.isClick && grid.isChecked) {
            grid.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        
        //  没有一个格子选中的时候
        if (grid.isChecked == false) {
            grid.isClick = true
            grid.isMove = true
            grid.isChecked = true
            
            //  获取移动格子的起始位置
            startPoint = longPressGesture.location(in: longPressGesture.view)
            //  获取移动格子的其实位置中心
            originPoint = grid.center
            
            //  给选中的格子添加方法的特效
            UIView
            .animate(withDuration: 0.5, animations: { 
                grid.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                grid.alpha = 1
                grid.setBackgroundImage(self.highlightedImage, for: .normal)
            })
        }
    }
    
    //  拖动位置
    func pressGestureStateChangeWith(gridPoint: CGPoint, gridItem: GridButton)
    {
        if (gridItem.isChecked && gridItem.isClick) {
            let gridBtns = self.gridBtns
            
            gridListView.bringSubview(toFront: gridItem)
            //  移动后的 X 坐标
            let deltaX = gridPoint.x - startPoint.x
            //  应用移动后的 Y 坐标
            let deltaY = gridPoint.y - startPoint.y
            //  拖动的应用跟随手势移动
            gridItem.center = CGPoint(x: gridItem.center.x + deltaX,
                                      y: gridItem.center.y + deltaY)
            
            //  移动的格子索引下标
            let fromIndex = gridItem.gridIndex
            //  移动到目标格子的索引下标
            let toIndex = GridButton.indexOf(point: gridItem.center, with: gridItem, gridListArray: gridBtns)
            let borderIndex = gridBtns.count - 1
            
            if (toIndex < 0 || toIndex >= borderIndex) {
                contain = false
            } else {
                //  获取移动到的目标格子
                let targetGrid = gridBtns[toIndex];
                gridItem.center = targetGrid.gridCenterPoint
                originPoint = targetGrid.gridCenterPoint
                gridItem.gridIndex = toIndex
                
                //  判断格子的移动方向，是从后往前还是从前往后拖动
                if (fromIndex - toIndex) > 0 {
                    //  从移动格子的位置开始,始终获取最后一个格子的索引位置
                    var lastGridIndex = fromIndex
                    
                    for _: Int in (toIndex)..<fromIndex {
                        let lastGrid: GridButton = gridBtns[lastGridIndex]
                        let preGrid = gridBtns[lastGridIndex]
                        UIView.animate(withDuration: 0.5, animations: {
                            preGrid.center = lastGrid.gridCenterPoint
                        })
                        //  试试更新格子的索引下标
                        preGrid.gridIndex = lastGridIndex
                        lastGridIndex -= 1
                    }
                    //  排列格子顺序和更新格子坐标信息
                    sortGridList()
                } else if (fromIndex - toIndex) < 0 {
                    //从前往后拖动格子
                    //从移动格子到目标格子之间的所有格子向前移动一格
                    for i: Int in (fromIndex)..<toIndex {
                        let topOneGrid = gridBtns[i]
                        let nextGrid = gridBtns[i]
                        //  实时更新格子的索引下标
                        nextGrid.gridIndex = i
                        UIView.animate(withDuration: 0.5, animations: {
                            nextGrid.center = topOneGrid.gridCenterPoint
                        })
                    }
                    
                    //  排列格子顺序和更新格子坐标信息
                    sortGridList()
                }

            }
        }
    }
    
    func pressGestureStateStateEnded(gridItem: GridButton)
    {
        if (gridItem.isChecked && gridItem.isChecked) {
            //  撤销格子的放大特效
            UIView.animate(withDuration: 0.5, animations: { 
                gridItem.transform = CGAffineTransform.identity
                gridItem.alpha = 1.0;
                gridItem.isChecked = false
                
                if (self.contain == false) {
                    gridItem.center = self.originPoint
                }
                
                gridItem.setNeedsLayout()
                gridItem.layoutSubviews()
            })
            
            sortGridList()
        }
    }
}
