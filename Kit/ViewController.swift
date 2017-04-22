//
//  ViewController.swift
//  Kit
//
//  Created by LuYaoChuan on 17/1/10.
//  Copyright © 2017年 Geek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btn: RotationButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JCToast.showMessage(text: "你好世界", in: self.view)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.backgroundColor = UIColor.blue
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func click(_ sender: UIButton)
    {
        let alertVc = AlertViewController(title: "标题", message: "信息")
        
        let action1 = AlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        
        let action2 = AlertAction(title: "确定", style: .default) { (action) in
            
        }
        
        let action3 = AlertAction(title: "爆炸", style: .destructive) { (action) in
            
        }
        
        alertVc.addAction(action: action1)
        alertVc.addAction(action: action2)
        alertVc.addAction(action: action3)
        
        btn.isAnimation = false
        
        present(alertVc, animated: false, completion: nil)
        
    }
    
    
}

