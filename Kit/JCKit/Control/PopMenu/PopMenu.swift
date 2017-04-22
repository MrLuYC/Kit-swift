//
//  PopMenu.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/18.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

fileprivate let keyWindow = UIApplication.shared.keyWindow
fileprivate let screenWidth = UIScreen.main.bounds.size.width
fileprivate let screenHeight = UIScreen.main.bounds.size.height


/// 弹出视图风格
///
/// - custom: 默认风格
/// - arrow: 带箭头的下拉框
public enum PopMenuType : Int
{
    case custom
    case arrow
}

/// 弹出方向,只有在上下或者左右都显示不下时,优先考虑的方向
///
/// - top: 上
/// - bottom: 下
/// - left: 左
/// - right: 右
public enum PopMenuDirection : Int
{
    case top
    case bottom
    case left
    case right
}

public typealias ActionBack = (_ indexPath: IndexPath) -> Void
public typealias CellBack = (_ indexPath: IndexPath) -> UITableViewCell
public typealias RowNumber = () -> Int
public typealias OptionCellHeight = () -> CGFloat

public class PopMenu: UITableView {

    //  MARK:- 设置 Cell
    public var cellBack: CellBack?
    public var rowNumber: RowNumber?
    public var opetionCellHeight: OptionCellHeight?
    
    //  MARK:- 事件回调
    /// 删除回调
    public var removeOption: ActionBack?
    /// 单击回调
    public var selectedOption: ActionBack?
    
    /// 选择样式,是否开启多选,默认为 false
    public var multoSelect: Bool = false
    
    /// 圆角半径,默认为5
    public var radius: CGFloat = 5 {
        didSet{
            self.layer.cornerRadius = 5
        }
    }
    
    //  MARK:- 起点便宜
    /// 最大显示行数,默认大于5行显示5行
    public var maxLine: CGFloat?
    /// 是否可以删除, true 时请在回调中删除对应数据
    public var canEdit: Bool?
    /// 样式
    public var optionType: PopMenuType = .custom
    
    /// 背景颜色
    public var backColor: UIColor? {
        didSet {
            self.backgroundColor = backColor
        }
    }
    
    /// 背景层颜色
    public var coverColor: UIColor?
    
    /// 缩放, false 竖直或者水平展架 true
    public var vhShow: Bool?
    
    /// 显示时,距离四周的间距,具体对其方式,可以自行个悲剧需求设置
    public var edgeInsets: UIEdgeInsets?
    
    fileprivate var cellHeight: CGFloat = 40.0
    
    
    init()
    {
        super.init(frame: CGRect.zero, style: .plain)
        
        self.delegate = self
        self.dataSource = self
        self.layer.masksToBounds = true
        self.showsVerticalScrollIndicator = false
        self.bounces = true
        self.separatorStyle = .none
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopMenu
{
    func initSetting()
    {
        backColor = UIColor.white
        coverColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        edgeInsets = UIEdgeInsets.zero
    }
}

extension PopMenu: UITableViewDelegate, UITableViewDataSource
{
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (rowNumber != nil) ? rowNumber!() : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if ((cellBack) != nil){
            let cell: UITableViewCell = cellBack!(indexPath)
            
            cell.backgroundColor = backColor
            cell.selectionStyle = .none
            
            return cell
        } else {
            let id = "cellID"
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: id)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (opetionCellHeight != nil) ? opetionCellHeight!() : cellHeight
    }
}
