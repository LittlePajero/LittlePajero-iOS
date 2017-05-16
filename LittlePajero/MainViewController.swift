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
import SwiftLocation                   // 固定时间间隔记录用户位置
import MaterialComponents.MaterialButtons

// 记录轨迹的状态
enum PresentWorkingMode : String {
    case idle
    case recording
    case pauseRecord
}

public extension UITextView {
    public func scrollBottom() {
        guard self.text.characters.count > 0 else {
            return
        }
        let stringLength:Int = self.text.characters.count
        self.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }
}

public extension CLLocation {
    
    public var shortDesc: String {
        return "- lat,lng=\(self.coordinate.latitude),\(self.coordinate.longitude), h-acc=\(self.horizontalAccuracy) mts\n"
    }
    
}

class MainViewController: UIViewController, MGLMapViewDelegate, APScheduledLocationManagerDelegate {

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var mainButton: UIButton!             // 中间大按钮
    @IBOutlet weak var infoButton: UIButton!             // 侧边 更多信息 按钮
    @IBOutlet weak var locationButton: UIButton!         // 侧边 回到当前位置 按钮
    @IBOutlet weak var userLocationLabel: UILabel!       // 用户位置
    @IBOutlet weak var pinDropButton: UIButton!          // 打点按钮
    @IBOutlet weak var pauseRecordButton: UIButton!      // 暂停记录轨迹按钮
    @IBOutlet weak var stopRecordButton: UIButton!       // 停止记录轨迹按钮
    @IBOutlet weak var continueRecordButton: UIButton!   // 继续记录轨迹按钮
    @IBOutlet weak var sideMenuButton: UIButton!         // 侧边栏按钮
    
    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var textViewAll: UITextView?
    
    private var currentRecordingPathId : Int? = nil
    
    private var manager: APScheduledLocationManager!     // 后台记录用户位置的 manager
    
    fileprivate let realm = try! Realm()
    
    override func viewDidLoad() {
        
        definesPresentationContext = true
        
        self.textView?.layoutManager.allowsNonContiguousLayout = false
        self.textViewAll?.layoutManager.allowsNonContiguousLayout = false
        
        self.mode = .idle
        
        super.viewDidLoad()
        
        // 设置 Status Bar 为浅色
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        // 设置 delegate 对象
        mapView.delegate = self
        // 后台记录用户位置的 manager
        manager = APScheduledLocationManager(delegate: self)

        // 设置地图中心为用户坐标
         mapView.userTrackingMode = .follow
        // 设置：地图中心
        // mapView.setCenter(CLLocationCoordinate2D(latitude: 45.52214, longitude: -122.63748), zoomLevel: 13, animated: false)

        
        // 设置 SubButtons 的样式(locationButton 和 infoButton)
        setSubButtonStyle()
        
        // 设置用户位置标签字体颜色
        userLocationLabel.textColor = UIColor.white
        
        // 设置侧边栏出场的样子
        setSideMenuStyle()
        
        // 打印出数据库地址
        print(realm.configuration.fileURL!)
    }
    
    private func log(_ value: String) {
        self.textView!.insertText(value)
        self.textView!.scrollBottom()
    }
    
    private func logAll(_ value: String) {
        self.textViewAll!.insertText(value)
        self.textViewAll!.scrollBottom()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Location.onChangeTrackerSettings = { settings in
            self.log(String(describing: settings))
        }
        
        var counts = 0
        let x = Location.getLocation(accuracy: .room, frequency: .continuous, timeout: 60*60*5, success: { (_, location) in
            self.log(location.shortDesc)
            
        }) { (request, last, error) in
            self.log("Location monitoring failed due to an error \(error)")
            
            request.cancel() // stop continous location monitoring on error
        }
        x.register(observer: LocObserver.onAuthDidChange(.main, { (request, oldAuth, newAuth) in
            print("Authorization moved from '\(oldAuth)' to '\(newAuth)'")
        }))
        
        let path = RealmPath()
        path.id = RealmPath.incrementID()
        try! self.realm.write {
            self.realm.add(path, update: false)
        }
        self.currentRecordingPathId = path.id
        print("create new path")
        
        Location.onReceiveNewLocation = { location in
            self.logAll(location.shortDesc)
            if counts < 8 {
                counts += 1
            } else {
                let userCurrentLocation = RealmLocation()
                userCurrentLocation.latitude = Float(location.coordinate.latitude)
                userCurrentLocation.longitude = Float(location.coordinate.longitude)
                userCurrentLocation.id = RealmLocation.incrementID()
                let currentPath = self.realm.object(ofType: RealmPath.self, forPrimaryKey: self.currentRecordingPathId)
                try! self.realm.write {
                    self.realm.add(userCurrentLocation, update: false)
                    // self.realm.add(path, update: true)
                    currentPath?.locations.append(userCurrentLocation)
                }
                
                print("succeed")
                currentPath?.transformToJSON()
                counts = 0
            }
        }
    }
    
    // 这个没用
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 将 mode 值从 actionViewController 传回来
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToAction" {
            let actionVC = segue.destination as! ActionViewController
            actionVC.mainVC = self
        }
        
        if segue.identifier == "mainToPinDrop" {
            let pinDropVC = segue.destination as! PinDropViewController
            pinDropVC.location = (sender as? String)!
            print("Sender Value:\(pinDropVC.location)")
        }
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
    
    // 什么模式都没有
    func setIdleInterface() {
        // 改变样式
        pinDropButton.isHidden        = true
        pauseRecordButton.isHidden    = true
        stopRecordButton.isHidden     = true
        continueRecordButton.isHidden = true
        userLocationLabel.isHidden    = true
    }
    
    // 开始记录路径的模式
    func recordingStart() {
        print("----- Start Recording")
        // 改变样式
        pinDropButton.isHidden        = false
        pauseRecordButton.isHidden    = false
        userLocationLabel.isHidden    = false
        mainButton.isHidden           = true
        // 记录轨迹
        //manager.startUpdatingLocation(interval: 10, acceptableLocationAccuracy: 10)
    }
    
    // 暂停记录路径的模式
    func pauseRecord() {
        // 改变样式
        pinDropButton.isHidden        = true
        pauseRecordButton.isHidden    = true
        stopRecordButton.isHidden     = false
        continueRecordButton.isHidden = false
        debugPrint("----- Pause clicked")
        //if self.manager.isRunning {
        //self.manager.stoptUpdatingLocation()
        //}
        // self.pauseOrContinueRecord()
    }
    
    @IBAction func pauseRecord(_ sender: UIButton) {
        self.mode = .pauseRecord
    }
    
    
    @IBAction func continueRecord(_ sender: UIButton) {
        self.mode = .recording
    }
    
    // 打点并且跳到添加打点内容的页面
    @IBAction func pinDrop(_ sender: UIButton) {
        let userCurrentLocation = mapView.userLocation!
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: userCurrentLocation.coordinate.latitude, longitude: userCurrentLocation.coordinate.longitude)
        mapView.addAnnotation(point)
        
        let currentPoint = RealmPoint()
        currentPoint.latitude = Float(point.coordinate.latitude)
        currentPoint.longitude = Float(point.coordinate.longitude)
        currentPoint.id = RealmPoint.incrementID()
        
        try! realm.write {
            realm.add(currentPoint)
        }
        
        let location = String(format: "%0.5f°, %0.5f°", userCurrentLocation.coordinate.latitude, userCurrentLocation.coordinate.longitude)
        performSegue(withIdentifier: "mainToPinDrop", sender: location)
        print("Location: \(location)")
    }

    /*
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
    */

    
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
        //    realm.deleteAll()
        //    realm.add(currentUserLocation)
        //    realm.add(path)
        //    let JSONString = Mapper().toJSON(path)
        //    print("\(JSONString)")
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
    
    // 设置 SubButton 的样式
    func setSubButtonStyle() {
        //infoButton.layer.backgroundColor = UIColor.white.cgColor
        //infoButton.layer.cornerRadius = 2
    
        //locationButton.layer.backgroundColor = UIColor.white.cgColor
        //locationButton.layer.cornerRadius = 2
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

