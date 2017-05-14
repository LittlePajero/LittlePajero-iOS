//
//  PinDropViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/14.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit

class PinDropViewController: UIViewController {
    
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var location: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 将背景设置为模糊
        setBackgroundBlur()

        desLabel.textColor = UIColor.white
        locationLabel.textColor = UIColor.white
        
        // 从 MainViewController 传 location 到这个页面
        locationLabel.text = "\(location)"
        print("传过来的location：\(location)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 设置背景为模糊
    func setBackgroundBlur() {
        
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
