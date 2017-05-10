//
//  ViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/5.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import Mapbox                          // 引入超级好用的地图
import SideMenu

class ViewController: UIViewController {

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var mainButton: UIButton!           // 中间大按钮
    @IBOutlet weak var infoButton: UIButton!           // 侧边 更多信息 按钮
    @IBOutlet weak var locationButton: UIButton!       // 侧边 回到当前位置 按钮
    @IBOutlet weak var searchBox: UISearchBar!         // 搜索框
    
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // 设置地图中心为用户坐标
        mapView.userTrackingMode = .follow
        
        // 设置 MainButton 的样式
        setMainButtonStyle()
        
        // 设置 SubButtons 的样式(locationButton 和 infoButton)
        setSubButtonStyle()
        
        searchBox.barTintColor = UIColor.white
        
        setSideMenuStyle()
    }

    func setSideMenuStyle() {
        SideMenuManager.menuAnimationTransformScaleFactor = CGFloat(1)
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuWidth = view.frame.width * CGFloat(0.78)
    }

    // 这个没用
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 设置 MainButton 的 style
    func setMainButtonStyle() {
        mainButton.layer.cornerRadius = mainButton.bounds.size.height / 2
        mainButton.layer.shadowColor = UIColor.gray.cgColor
        mainButton.layer.shadowOffset = CGSize.zero
        mainButton.layer.shadowOpacity = 0.5
        mainButton.layer.shadowRadius = 1
        //mainButton.layer.shadowPath = UIBezierPath(rect: mainButton.bounds).cgPath
        mainButton.layer.shouldRasterize = true
        mainButton.layer.borderWidth = 0
        //mainButton.layer.borderColor = UIColor.white.cgColor
    }
    
    // 设置 SubButton 的样式
    func setSubButtonStyle() {
        infoButton.layer.backgroundColor = UIColor.white.cgColor
        infoButton.layer.cornerRadius = 2
    
        locationButton.layer.backgroundColor = UIColor.white.cgColor
        locationButton.layer.cornerRadius = 2
    }
    
    @IBAction func returnUserLocation(_ sender: UIButton) {
        mapView.setCenter((mapView.userLocation?.coordinate)!, zoomLevel: 13, animated: true)
    }
    
}

