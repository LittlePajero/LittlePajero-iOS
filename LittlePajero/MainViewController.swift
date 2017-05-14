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
import RealmSwift
import CoreLocation                    // 用APS，获取地理位置信息的库（自带）
import ObjectMapper
import ObjectMapper_Realm
import MaterialComponents.MaterialButtons

enum PresentWorkingMode : String {
    case idle
    case recording
    case pauseRecord
}

class MainViewController: UIViewController, MGLMapViewDelegate, APScheduledLocationManagerDelegate {

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var mainButton: UIButton!             // 中间大按钮
    @IBOutlet weak var infoButton: UIButton!             // 侧边 更多信息 按钮
    @IBOutlet weak var locationButton: UIButton!         // 侧边 回到当前位置 按钮
    @IBOutlet weak var userLocationLabel: UILabel!       // 用户位置
    @IBOutlet weak var pinOrStopButton: UIButton!        // 打点或者停止记录轨迹按钮
    @IBOutlet weak var pauseOrContinueButton: UIButton!  // 暂停或者继续 记录位置按钮
    @IBOutlet weak var sideMenuButton: UIButton!
    
    private var manager: APScheduledLocationManager!     // 后台记录用户位置的 manager
    
    fileprivate let realm = try! Realm()
    
    override func viewDidLoad() {
        
        self.mode = .idle
        
        super.viewDidLoad()
        
        // 设置 delegate 对象
        mapView.delegate = self
        // 后台记录用户位置的 manager
        manager = APScheduledLocationManager(delegate: self)

        // 设置地图中心为用户坐标
        mapView.userTrackingMode = .follow
        // 设置：地图中心
        //mapView.setCenter(CLLocationCoordinate2D(latitude: 45.52214, longitude: -122.63748), zoomLevel: 13, animated: false)

        
        // 设置几个大按钮的样式
        setMainButtonStyle()
        
        // 设置 SubButtons 的样式(locationButton 和 infoButton)
        setSubButtonStyle()
        
        // 设置用户位置标签字体颜色
        userLocationLabel.textColor = UIColor.white
        
        // 设置侧边栏出场的样子
        setSideMenuStyle()
        
        // 打印出数据库地址
        print(realm.configuration.fileURL!)
        
    }

    // 这个没用
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 判断当前模式，以更换界面
    private var _mode : PresentWorkingMode = .idle
    var mode : PresentWorkingMode {
        set {
            self._mode = newValue
            switch newValue {
            case .idle : self.setIdleInterface()
            case .recording : self.recordingStart()
            case .pauseRecord : self.pauseRecord()
            }
        }
        get {
            return self._mode
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToAction" {
            let secondController = segue.destination as! ActionViewController
            secondController.mainVC = self
        }
    }
    
    // 什么模式都没有
    func setIdleInterface() {
        pinOrStopButton.isHidden          = true
        pauseOrContinueButton.isHidden    = true
        userLocationLabel.isHidden        = true
    }
    
    // 开始记录路径的模式
    func recordingStart() {
        // 改变样式
        pinOrStopButton.isHidden          = false
        pauseOrContinueButton.isHidden    = false
        userLocationLabel.isHidden        = false
        mainButton.isHidden               = true
        // 记录轨迹
        manager.startUpdatingLocation(interval: 2, acceptableLocationAccuracy: 10)
    }
    
    // 暂停记录路径的模式
    func pauseRecord() {
        debugPrint("----- Pause clicked")
        //if self.manager.isRunning {
        //    self.manager.stoptUpdatingLocation()
        //}
        self.pauseOrContinueRecord()
    }
    
    @IBAction func pause(_ sender: UIButton) {
        self.mode = .pauseRecord
    }
    
    

    func pauseOrContinueRecord() {
        // self.mode = .pauseRecord
        if manager.isRunning {
            //pauseOrContinueButton.setImage(#imageLiteral(resourceName: "playArrowMaterial"), for: .normal)
            //pinOrStopButton.setImage(#imageLiteral(resourceName: "rectangle5"), for: .normal)
            manager.stoptUpdatingLocation()
        }else{
            if CLLocationManager.authorizationStatus() == .authorizedAlways {
                //pauseOrContinueButton.setImage(#imageLiteral(resourceName: "pauseMaterial"), for: .normal)
                //pinOrStopButton.setImage(#imageLiteral(resourceName: "pinDropMaterial"), for: .normal)
                manager.startUpdatingLocation(interval: 2, acceptableLocationAccuracy: 100)
            }else{
                manager.requestAlwaysAuthorization()
            }
        }
    }

    
    //-------------------- 后台记录位置的 delegate 方法 --------------------------//
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didUpdateLocations locations: [CLLocation]) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        let userLocation = locations.first!
        print("当前模式：\(self.mode)")
        print("\(formatter.string(from: Date())) loc: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
        
        //let currentUserLocation = Location()
        //currentUserLocation.latitude = Float(userLocation.coordinate.latitude)
        //currentUserLocation.longitude = Float(userLocation.coordinate.longitude)
        //let path = Path()
        //path.locations.append(currentUserLocation)
        // print("\(path)")
        //try! realm.write {
        //    realm.add(currentUserLocation)
        //    realm.add(path)
            //let JSONString = Mapper().toJSON(path)
            // print("\(JSONString)")
        //}
        
        //let JSONString = Mapper().toJSON(currentUserLocation)

        
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didFailWithError error: Error) {
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    //----------------------------------------------------------------------------//
    
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
        setCircleButtonStyle(pinOrStopButton, UIColor.lpBackgroundWhite)
        setCircleButtonStyle(pauseOrContinueButton, UIColor.lpBackgroundWhite)
        //addShadow(mainButton)
        //addShadow(pinOrStopButton)
        //addShadow(pauseOrContinueButton)
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

