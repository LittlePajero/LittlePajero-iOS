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

enum PresentWorkingMode : String {
    case idle
    case recording
    case pauseRecord
}

class MainViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var mainButton: UIButton!           // 中间大按钮
    @IBOutlet weak var infoButton: UIButton!           // 侧边 更多信息 按钮
    @IBOutlet weak var locationButton: UIButton!       // 侧边 回到当前位置 按钮
    @IBOutlet weak var searchBox: UISearchBar!         // 搜索框
    @IBOutlet weak var userLocationLabel: UILabel!     // 用户位置
    @IBOutlet weak var pinDropButton: UIButton!        // 打点按钮
    @IBOutlet weak var pauseButton: UIButton!          // 暂停记录位置按钮
    
    override func viewDidLoad() {
        
        self.mode = .idle
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // 设置地图中心为用户坐标
        mapView.userTrackingMode = .follow
        
        // 设置 MainButton 的样式
        setMainButtonStyle()
        
        // 设置 SubButtons 的样式(locationButton 和 infoButton)
        setSubButtonStyle()
        
        // 设置 delegate 对象
        mapView.delegate = self
        
        // 设置用户位置标签字体颜色
        userLocationLabel.textColor = UIColor.white
        
        // 设置搜索框的背景
        searchBox.barTintColor = UIColor.white
        
        // 设置侧边栏出场的样子
        setSideMenuStyle()
        
    }

    // 这个没用
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var mode : PresentWorkingMode {
        set {
            //self.mode = newValue
            switch newValue {
            case .idle : self.setIdleInterface()
            case .recording : self.recordingStart()
            case .pauseRecord : break
            }
        }
        get {
            return self.mode
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToAction" {
            let secondController = segue.destination as! ActionViewController
            secondController.mainVC = self
        }
    }
    
    func setIdleInterface() {
        pinDropButton.isHidden = true
        pauseButton.isHidden = true
        userLocationLabel.isHidden = true
    }
    
    func recordingStart() {
        pinDropButton.isHidden = false
        pauseButton.isHidden = false
        userLocationLabel.isHidden = false
        mainButton.isHidden = true
    }
    
    func pauseRecord() {
        
    }
    
    // 侧边栏样式
    func setSideMenuStyle() {
        SideMenuManager.menuAnimationTransformScaleFactor = CGFloat(1)
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuWidth = view.frame.width * CGFloat(0.78)
    }
    
    // 设置大型按钮的样式
    func setMainButtonStyle() {
        setCircleButtonStyle(mainButton, UIColor.clear)
        setCircleButtonStyle(pinDropButton, UIColor.white)
        setCircleButtonStyle(pauseButton, UIColor.white)
        addShadow(mainButton)
        addShadow(pinDropButton)
        addShadow(pauseButton)
    }
    
    // 添加阴影
    func addShadow(_ sender: UIButton) {
        sender.layer.shadowColor = UIColor.darkGray.cgColor
        sender.layer.shadowOffset = CGSize.init(width: 1, height: 3)
        sender.layer.shadowOpacity = 0.7
        sender.layer.shadowRadius = 0
        sender.layer.masksToBounds = false
        sender.layer.shadowRadius = 1
    }
    
    // 设置按钮样式
    func setCircleButtonStyle(_ button: UIButton, _ bgColor: UIColor) {
        button.layer.backgroundColor = bgColor.cgColor
        button.layer.cornerRadius = button.bounds.height / 2
    }
    
    // 设置 SubButton 的样式
    func setSubButtonStyle() {
        infoButton.layer.backgroundColor = UIColor.white.cgColor
        infoButton.layer.cornerRadius = 2
    
        locationButton.layer.backgroundColor = UIColor.white.cgColor
        locationButton.layer.cornerRadius = 2
    }
    
    // 返回用户当前位置
    @IBAction func returnUserLocation(_ sender: UIButton) {
        mapView.setCenter((mapView.userLocation?.coordinate)!, zoomLevel: 13, animated: true)
    }
    
    // MGLMapViewDelegate 的方法 —— 用户位置变化就更新位置
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        // 打印用户位置
        let userLocation = mapView.userLocation!
        userLocationLabel.text = String(format: "%0.5f°, %0.5f°", userLocation.coordinate.latitude, userLocation.coordinate.longitude)
    }
    
}

