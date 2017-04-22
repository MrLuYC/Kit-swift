//
//  ImageAutoScrollView.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/17.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit


/// 自定义的下载图片的回调方法
public typealias DownLoadImage = (_ button: UIButton, _ url: URL) -> Void

/// 协议
public protocol ImageAutoScrollViewDelegate: NSObjectProtocol
{
    func imageAutoScrollView(view: ImageAutoScrollView, didClick index: Int)
}

@IBDesignable public class ImageAutoScrollView: UIView
{
 
    /// 定时器
    var timer: Timer?
    
    public var downLoadImage: DownLoadImage?
    
    /// 代理
    @IBInspectable public var delegate: ImageAutoScrollViewDelegate?
    
    /// 自动滚动间隔时间
    @IBInspectable public var scrollIntervarTime:CGFloat = 1.0
    
    /// 是否循环滚动
    @IBInspectable public var isLoopScroll: Bool = false
    
    /// 页数
    @IBInspectable public var numberOfOages: Int = 0 {
        didSet {
            pageControl.numberOfPages = numberOfOages
        }
    }
    
    /// 是否自动滚动,默认为不自动滚动
    @IBInspectable public var isAutoScroll: Bool = false {
        didSet {
            if (isAutoScroll) {
                startTimer()
            }else {
                stopTimer()
            }
        }
    }
    
    /// 页标正常的颜色, 默认为灰色
    @IBInspectable public var pageNormalColor: UIColor = UIColor.gray {
        didSet{
            pageControl.pageIndicatorTintColor = pageNormalColor
        }
    }
    
    /// 页标高亮时的颜色, 默认为红色
    @IBInspectable public var pageHighilgColor: UIColor = UIColor.red {
        didSet {
            pageControl.currentPageIndicatorTintColor = pageHighilgColor
        }
    }
    
    /// 是否隐藏 pageControll, 默认为不隐藏
    @IBInspectable public var isHiddenPage: Bool = false {
        didSet {
            pageControl.isHidden = isHiddenPage
        }
    }
    
    /// MARK:- 懒加载属性
    
    /// 滚动视图
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //  设置分页
        scrollView.isPagingEnabled = true
        //  不显示纵向滚动条
        scrollView.showsVerticalScrollIndicator = false
        //  不显示横向滚动条
        scrollView.showsHorizontalScrollIndicator = false
        //  设置代理
        scrollView.delegate = self
        
        return scrollView
    }()
    
    /// 页标控制器
    lazy var pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        
        return pageControl
    }()
    
    
    /// 图片按钮集合
    var btns: Array<UIButton> = {
        var btns = Array<UIButton>()
        
        return btns
    }()
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        self.addSubview(scrollView)
        self.addSubview(pageControl)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - custom function
extension ImageAutoScrollView
{
    /// 设置图片集
    ///
    /// - Parameter images: 图片数组
    public func setupImages(with images: Array<UIImage>)
    {
        numberOfOages = images.count
        
        //  移除之前的图片
        for btn in btns {
            btn.removeFromSuperview()
        }
        btns.removeAll()
        
        var index = 0
        for image in images {
            let btn = UIButton(type: .custom)
            btn.imageView?.contentMode = .scaleAspectFill
            btn.imageView?.clipsToBounds = true
            btn.setBackgroundImage(image, for: .normal)
            btn.contentVerticalAlignment = .fill;
            btn.contentHorizontalAlignment = .fill;
            btn.tag = index
            btn.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
            scrollView.addSubview(btn)
            btns.append(btn)
            
            index += 1
        }
        
        setNeedsLayout()
    }
    
    /// 设置图片集
    ///
    /// - Parameter urls: 包含图片地址信息的字符串数组
    public func setupImage(with urls: Array<String>)
    {
        numberOfOages = urls.count
        
        //  移除之前的图片
        for btn in btns {
            btn.removeFromSuperview()
        }
        btns.removeAll()
        
        var index = 0
        
        for url in urls {
            let btn = UIButton(type: .custom)
            btn.imageView?.contentMode = .scaleAspectFill
            btn.imageView?.clipsToBounds = true
            btn.contentVerticalAlignment = .fill;
            btn.contentHorizontalAlignment = .fill
            btn.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
            
            let urlStr = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            let url = URL(string: urlStr!)
            
            downLoadImage!(btn, url!)
            
            scrollView.addSubview(btn)
            
            btns.append(btn)
            
            index += 1
        }

    }
    
    
    /// 插入一张图片
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - page: 位置
    public func insert(image: UIImage, page: Int)
    {
        
    }
    
    
    /// 移除指定位置的图片
    ///
    /// - Parameter page: 位置
    public func remove(page: Int)
    {
        
    }
}


// MARK: - 轮播功能实现
extension ImageAutoScrollView
{
    
    /// 开始定时器
    func startTimer()
    {
        if (timer == nil){
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(scrollIntervarTime), target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .commonModes)
        }
    }
    
    /// 关闭定时器
    func stopTimer()
    {
        if (timer != nil){
            timer?.invalidate()
            timer = nil
        }
    }
    
    /// 下一张
    func nextPage()
    {
        var page: Int = 0
        
        if (pageControl.currentPage < numberOfOages - 1){
            page = pageControl.currentPage + 1
        } else {
            if (isLoopScroll){
                page = 0
            } else {
                stopTimer()
                return
            }
        }
        
        let offsetX = CGFloat(page) * scrollView.frame.size.width
        let offset = CGPoint(x: offsetX, y: 0.0)
        
        scrollView.setContentOffset(offset, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension ImageAutoScrollView: UIScrollViewDelegate
{
    
    /// 图片视图滚动
    ///
    /// - Parameter scrollView: 滚动视图
    public func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        pageControl.currentPage = Int((scrollView.contentOffset.x + scrollView.frame.size.width * 0.5) / frame.size.width)
        
    }
    
    /// 开始拖动
    ///
    /// - Parameter scrollView: 滚动视图
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        if (isAutoScroll){
            stopTimer()
        }
    }
    
    /// 停止拖动
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        if (isAutoScroll){
            startTimer()
        }
    }
}


// MARK: - Event
extension ImageAutoScrollView
{
    func clickBtn(sender: UIButton)
    {
        delegate?.imageAutoScrollView(view: self, didClick: sender.tag)
    }
}
