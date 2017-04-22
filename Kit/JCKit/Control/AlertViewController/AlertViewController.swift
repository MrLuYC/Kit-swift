//
//  AlertViewController.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/18.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

fileprivate let themeColor = UIColor(red: 94.0 / 255.0, green: 96.0 / 255.0, blue: 102 / 255.0, alpha: 1.0)

public enum AlertViewControlllerStyle
{
    case actionSheet
    case alert
}

class AlertViewController: UIViewController {

    fileprivate(set) lazy var actions:Array<AlertAction> = {
        let actions = Array<AlertAction>()
        return actions
    }()
    
    fileprivate var shadowView: UIView?
    fileprivate var contentView: UIView?
    fileprivate var contentMargin: UIEdgeInsets?
    fileprivate var contentViewWidth: CGFloat?
    fileprivate var buttonHeight: CGFloat?
    fileprivate var firstDisplay: Bool?
    
    override open var title: String? {
        set (newValue){
            super.title = newValue
            self.titleLabel.text = newValue
        }
        get {
            return super.title
        }
        
    }
    
    open var messageAlignment: NSTextAlignment? {
        didSet{
            messageLabel.textAlignment = messageAlignment!
        }
    }
    
    open var message: String? {
        didSet{
            messageLabel.text = message
        }
    }

    /// MARK:- 懒加载
    
    lazy var titleLabel: UILabel = {
        let titleLabel: UILabel = self.createLabel(fontSize: 20)
        titleLabel.text = self.title
        titleLabel.textAlignment = .center
        
        return titleLabel
        
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel: UILabel = self.createLabel(fontSize: 15)
        messageLabel.text = self.message
        messageLabel.textAlignment = self.messageAlignment!
        
        return messageLabel
    }()
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        defaultSetting()
        
    }
    
    public convenience init(title: String, message: String)
    {
        self.init()
        self.title = title
        self.message = message
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createShadowView()
        createContenView()
        createAllButtons()
        createAllSeparatorLine()
        
        contentView?.addSubview(titleLabel)
        contentView?.addSubview(messageLabel)
        
        titleLabel.text = title
        messageLabel.text = message
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = UIColor.clear
        
        //  更新标题的 frame
        updateTitleLabelFrame()
        
        //  更新 message的 frame
        updateMessageLabelFrame()
        
        //  更新按钮的 frame
        updateAllButtonsFrame()
        
        //  更新分割线的 frame
        updateAllSeparatorLineFrame()
        
        //  更新弹出框的 frame
        upodateShadowAndContentViewFrame()
        
        //  显示弹出动画
        showAppearAnimation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


// MARK: - 创建内部视图
extension AlertViewController
{
    
    func defaultSetting()
    {
        contentMargin = UIEdgeInsetsMake(25.0, 20.0, 0.0, 20.0)
        contentViewWidth = 285
        buttonHeight = 45
        firstDisplay = true
        messageAlignment = .center
    }
    
    /// 阴影层
    func createShadowView()
    {
        shadowView = UIView(frame: CGRect(x: 0, y: 0, width: contentViewWidth!, height: 175))
        shadowView?.layer.masksToBounds = false
        shadowView?.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        shadowView?.layer.shadowRadius = 20
        shadowView?.layer.shadowOpacity = 1
        shadowView?.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.view.addSubview(shadowView!)
    }
    
    /// 内容层
    func createContenView()
    {
        contentView = UIView(frame: (shadowView?.bounds)!)
        contentView?.backgroundColor = UIColor(red: 250 / 255.0, green: 251.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
        contentView?.layer.cornerRadius = 13.0
        contentView?.clipsToBounds = true
        shadowView?.addSubview(contentView!)
    }
    
    /// 创建所有的按钮
    func createAllButtons()
    {
        for i in 0 ..< (actions.count){
            let btn = HighLightButton()
            btn.tag = 10 + i
            btn.highlightedColor = UIColor(white: 0.93, alpha: 1.0)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            let color = actions[i].style == .destructive ? UIColor.red : themeColor
            btn.setTitleColor(color, for: .normal)
            btn.setTitle(actions[i].title, for: .normal)
            btn.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
            contentView?.addSubview(btn)
        }
    }
    
    
    /// 创建所有的分割线
    func createAllSeparatorLine()
    {
        if (actions.count == 0){
            return
        }
        
        //  要创建个分割线条数
        var linesAmount = (actions.count) > 2 ? actions.count : 1
        let result = (title?.isEmpty == false) || (message?.isEmpty == false) ? 0 : 1
        linesAmount -= result
        
        for i in 0 ..< linesAmount {
            let separatorLine = UIView()
            separatorLine.tag = 1000 + i
            separatorLine.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
            contentView?.addSubview(separatorLine)
        }
    }
    
    func updateTitleLabelFrame()
    {
        let labelWidth = contentViewWidth! - (contentMargin?.left)! - (contentMargin?.right)!
        var titleHeight: CGFloat = 0.0
        if (title?.isEmpty == false){
            let size = titleLabel.sizeThatFits(CGSize(width: labelWidth, height: CGFloat(MAXFLOAT)))
            titleHeight = size.height
            titleLabel.frame = CGRect(x: (contentMargin?.left)!, y: (contentMargin?.top)!, width: labelWidth, height: titleHeight)
        }
    }
    
    func updateMessageLabelFrame()
    {
        let labelWidth = contentViewWidth! - (contentMargin?.left)! - (contentMargin?.right)!
        //  更新 message 的 frame
        var messageHeight:CGFloat = 0.0
        let messageY = (title?.isEmpty == false) ? titleLabel.frame.maxY + 20.0 : contentMargin?.top
        if (message?.isEmpty == false){
            let size = messageLabel.sizeThatFits(CGSize(width: labelWidth, height: CGFloat(MAXFLOAT)))
            messageHeight = size.height
            messageLabel.frame = CGRect(x: (contentMargin?.left)!, y: messageY!, width: labelWidth, height: messageHeight)
            
        }
    }
    
    func updateAllButtonsFrame()
    {
        if (actions.count == 0){
            return
        }
        
        let firstButtonY = getFirstButtonY()
        
        let buttonWidth = (actions.count) > 2 ? contentViewWidth : contentViewWidth! / CGFloat((actions.count))
        
        for i in 0 ..< (actions.count){
            let btn = contentView?.viewWithTag(10 + i)
            let buttonX = (actions.count) > 2 ? 0 : buttonWidth! * CGFloat(i)
            let buttonY = (actions.count) > 2 ? firstButtonY + buttonHeight! * CGFloat(i) : firstButtonY
            
            btn?.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth!, height: buttonHeight!)
        }
    }
    
    func updateAllSeparatorLineFrame()
    {
        //  分割线的条数
        var linesAmount = (actions.count) > 2 ? actions.count : 1
        let result = title?.isEmpty == false || message?.isEmpty == false
        linesAmount -= result ? 0 : 1
        let offsetAmount = result ? 0 : 1
        for i in 0 ..< linesAmount {
            //  获取到对应分割线
            let separatorLine = contentView?.viewWithTag(1000 + i)
            //  获取到对应的按钮
            let btn = contentView?.viewWithTag(10 + i + offsetAmount)
            
            let x = linesAmount == 1 ? contentMargin?.left : btn?.frame.origin.x
            let y = btn?.frame.origin.y
            let width = linesAmount == 1 ? contentViewWidth! - (contentMargin?.left)! - (contentMargin?.right)! : contentViewWidth
            separatorLine?.frame = CGRect(x: x!, y: y!, width: width!, height: 0.5)
        }
    }
    
    func upodateShadowAndContentViewFrame()
    {
        let firstButtonY = getFirstButtonY()
        
        var allButtonHeight: CGFloat = 0.0
        if ((actions.count) == 0){
            allButtonHeight = 0.0
        } else if ((actions.count) < 3) {
            allButtonHeight = buttonHeight!
        } else {
            allButtonHeight = buttonHeight! * CGFloat((actions.count))
        }
        
        //  更新警告框 frame
        var frame = shadowView?.frame
        frame?.size.height = firstButtonY + allButtonHeight
        shadowView?.frame = frame!
        
        shadowView?.center = self.view.center
        contentView?.frame = (shadowView?.bounds)!
        
    }
    
    func createLabel(fontSize: CGFloat) -> UILabel
    {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: fontSize)
        
        label.textColor = themeColor
        
        return label
    }
    
    func getFirstButtonY() -> CGFloat
    {
        var firstButtonY: CGFloat = 0.0
        if (title?.isEmpty == false){
            firstButtonY = titleLabel.frame.maxY
        }
        if (message?.isEmpty == false){
            firstButtonY = messageLabel.frame.maxY
        }
        
        firstButtonY += firstButtonY > 0 ? 15 : 0
        return firstButtonY
    }
    
    func addAction(action: AlertAction)
    {
        actions.append(action)
    }
}


// MARK: - 动画效果
extension AlertViewController
{
    func showAppearAnimation()
    {
        if(firstDisplay)!{
            firstDisplay = false
            shadowView?.alpha = 0
            shadowView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            UIView.animate(withDuration: TimeInterval(0.5), delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 10, options: .curveEaseIn, animations: { 
                self.shadowView?.transform = .identity
                self.shadowView?.alpha = 1
            }, completion: nil)
        }
    }
    
    func showDisappearAnimation()
    {
        UIView.animate(withDuration: TimeInterval(0.1), animations: { 
            self.contentView?.alpha = 0
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}


// MARK: - 事件
extension AlertViewController
{
    func didClickButton(sender: UIButton)
    {
        let action: AlertAction = (actions[sender.tag - 10])
        
        if (action.actionHandler != nil){
            action.actionHandler!(action)
        }
        
        showDisappearAnimation()
    }
}
