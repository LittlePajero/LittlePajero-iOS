//
//  StopViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/17.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import Mapbox

class StopRecordViewController: UIViewController, MGLMapViewDelegate{
    
    @IBOutlet var mapView: MGLMapView!
    
    var mainVC : MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置地图中心为用户坐标
        mapView.userTrackingMode = .follow
        
        // 将背景设置为模糊
        setBackgroundBlur()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 点击按钮返回
    @IBAction func backToMainVC() {
        self.mainVC?.mode = .idle
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
    
    
}
