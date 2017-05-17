//
//  StopViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/17.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit

class StopViewController: UIViewController {
    
    @IBOutlet weak var desLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 将背景设置为模糊
        setBackgroundBlur()
        
        // 设置按钮文字样式
        setLabelStyle()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 点击按钮返回
    @IBAction func backToMainVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 设置背景为模糊
    func setBackgroundBlur() {
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 1
        self.view.insertSubview(blurEffectView, at: 0)
        
        blurEffectView.heroModifiers = [.fade]
    }
    
    // 设置按钮文字样式
    func setLabelStyle() {
        desLabel.textColor = UIColor.white
    }

}