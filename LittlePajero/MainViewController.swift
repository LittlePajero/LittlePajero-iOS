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

// 状态
enum PresentWorkingMode {
    case idle
    case recording
    case pauseRecord
    case continueRecord
    case stopRecord
    case searching(String)
    case downloading
}

public extension CLLocation {
    
    public var shortDesc: String {
        return "- lat,lng=\(self.coordinate.latitude),\(self.coordinate.longitude), h-acc=\(self.horizontalAccuracy) mts\n"
    }
    
}

class MainViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!
    
    @IBOutlet weak var mainButton: UIButton!             // 中间大按钮
    @IBOutlet weak var infoButton: UIButton!             // 侧边 更多信息 按钮
    @IBOutlet weak var locationButton: UIButton!         // 侧边 回到当前位置 按钮
    @IBOutlet weak var userLocationLabel: UILabel!       // 用户位置
    @IBOutlet weak var pinDropButton: UIButton!          // 打点按钮
    @IBOutlet weak var pauseRecordButton: UIButton!      // 暂停记录轨迹按钮
    @IBOutlet weak var stopRecordButton: UIButton!       // 停止记录轨迹按钮
    @IBOutlet weak var continueRecordButton: UIButton!   // 继续记录轨迹按钮
    @IBOutlet var searchingBarBarBar: SearchingBar!
    @IBOutlet var searchSelections: UIStackView!
    @IBOutlet weak var downloadDone: OrangeButton!

    var mask : UIVisualEffectView? = nil
    
    private var currentRecordingPathId : Int? = nil
    
    var timer: Timer?
    var polylineSource: MGLShapeSource?
    // var currentIndex = 1
    var allCoordinates: [CLLocationCoordinate2D]!    // 这个没用了
    var progressView: UIProgressView!                // 下载地图的进度条
    
    fileprivate let realm = try! Realm()
    
    override func viewDidLoad() {
        
        definesPresentationContext = true
        
        self.mode = .idle
        
        super.viewDidLoad()
        
        // 设置 Status Bar 为浅色
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        // 搜索框代理
        searchingBarBarBar.textFieldDelegate = self
        let textField = self.searchingBarBarBar.viewWithTag(2) as! SearchingBarTextField
        textField.delegate = self

        // 设置 delegate 对象
        mapView.delegate = self

        // 设置地图中心为用户坐标
        mapView.userTrackingMode = .follow
        // 设置：地图中心
        //mapView.setCenter(CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417), zoomLevel: 13, animated: false)

        // 设置用户位置标签字体颜色
        userLocationLabel.textColor = UIColor.white
        
        // 设置侧边栏出场的样子
        setSideMenuStyle()
        
        // 打印出数据库地址
        print(realm.configuration.fileURL!)
        
        // 定义打印路径的点
        //allCoordinates = coordinates()
    }
    
    // 这个没用
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 传值的时候找到对应 ControllerView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToAction" {
            let actionVC = segue.destination as! ActionViewController
            actionVC.mainVC = self
        }
        
        if segue.identifier == "mainToPinDrop" {
            let pinDropVC = segue.destination as! PinDropViewController
            pinDropVC.location = mapView.userLocation
            pinDropVC.pathId = currentRecordingPathId!
        }
        
        if segue.identifier == "mainToStopRecord" {
            let navVC = segue.destination as! UINavigationController
            let stopRecordVC = navVC.viewControllers.first as! StopRecordViewController
            stopRecordVC.mainVC = self
            stopRecordVC.currentPathId = (sender as? Int)!
            print("Sender Value:\(stopRecordVC.currentPathId)")
        }
        
        if segue.identifier == "mainToSideMenu" {
            let navVC = segue.destination as! UINavigationController
            let sideMenuVC = navVC.viewControllers.first as! MenuViewController
            sideMenuVC.mainVC = self
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
            case .continueRecord : self.continueRecord()
            case .stopRecord : self.stopRecord()
            case .downloading : self.downloadMap()
            default: break
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
        downloadDone.isHidden         = true
    }
    
    // 开始记录路径的模式
    func recordingStart() {
        print("----- Start Recording")
        // 改变样式
        pinDropButton.isHidden        = false
        pauseRecordButton.isHidden    = false
        userLocationLabel.isHidden    = false
        mainButton.isHidden           = true
        
        // 先产生一条新的 path
        let path = RealmPath()
        path.id = RealmPath.incrementID()
        try! self.realm.write {
            self.realm.add(path, update: false)
        }
        
        // 这里改的 path 的 id !!!!!!!!!!!!!!!!!!
        self.currentRecordingPathId = path.id
        
        // 固定时间执行 tickPoint 方法
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(tickPoint), userInfo: nil, repeats: true)
    }
    
    // 打点的方法
    func tickPoint() {
        // 记录用户当前坐标
        let userCurrentLocation = RealmLocation()
        userCurrentLocation.latitude = (mapView.userLocation?.coordinate.latitude)!
        userCurrentLocation.longitude = (mapView.userLocation?.coordinate.longitude)!
        userCurrentLocation.id = RealmLocation.incrementID()
        let currentPath = self.realm.object(ofType: RealmPath.self, forPrimaryKey: self.currentRecordingPathId)
        // 存进 realm 中
        try! realm.write {
            realm.add(userCurrentLocation)
            currentPath?.locations.append(userCurrentLocation)
        }
        // 每次更新的时候还要画线
        let pathCoordinates = currentPath?.coordinates()
        print(pathCoordinates!)
        self.updatePolylineWithCoordinates(coordinates: pathCoordinates!)
    }
    
    // 页面加载出来之后执行的方法们
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        addLayer(to: style)
    }
    
    // 这里写了画线的样式
    func addLayer(to style: MGLStyle) {
        // Add an empty MGLShapeSource, we’ll keep a reference to this and add points to this later.
        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
        style.addSource(source)
        polylineSource = source
        
        // Add a layer to style our polyline.
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        layer.lineJoin = MGLStyleValue(rawValue: NSValue(mglLineJoin: .round))
        layer.lineCap = MGLStyleValue(rawValue: NSValue(mglLineCap: .round))
        layer.lineColor = MGLStyleValue(rawValue: UIColor.lpBlueLine)
        layer.lineWidth = MGLStyleFunction(interpolationMode: .exponential,
                                           cameraStops: [14: MGLConstantStyleValue<NSNumber>(rawValue: 5),
                                                         18: MGLConstantStyleValue<NSNumber>(rawValue: 20)],
                                           options: [.defaultValue : MGLConstantStyleValue<NSNumber>(rawValue: 1.5)])
        style.addLayer(layer)
    }

    // 更新路线
    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        
        polylineSource?.shape = polyline
        
        print("update polyline ============")
        //debugPrint(polylineSource)
    }
    
    // 暂停记录路径的模式
    func pauseRecord() {
        debugPrint("----- Pause clicked")
        // 改变样式
        pinDropButton.isHidden        = true
        pauseRecordButton.isHidden    = true
        stopRecordButton.isHidden     = false
        continueRecordButton.isHidden = false
        
        // 暂停记录轨迹
        timer?.invalidate()
    }
    
    // 继续记录轨迹
    func continueRecord() {
        // 改变样式
        pinDropButton.isHidden        = false
        pauseRecordButton.isHidden    = false
        stopRecordButton.isHidden     = true
        continueRecordButton.isHidden = true
        
        // 继续记录轨迹
        debugPrint("----- Continue clicked")
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(tickPoint), userInfo: nil, repeats: true)
    }
    
    func stopRecord() {
        // 改变样式
        stopRecordButton.isHidden     = true
        continueRecordButton.isHidden = true
        mainButton.isHidden           = false
        
        // 停止记录轨迹
        timer?.invalidate()
    }
    
    @IBAction func pauseRecord(_ sender: UIButton) {
        self.mode = .pauseRecord
    }
    
    @IBAction func continueRecord(_ sender: UIButton) {
        self.mode = .continueRecord
    }
    
    @IBAction func stopRecord(_ sender: UIButton) {
        self.mode = .stopRecord
        
        // 传递 currentRecordingpath 到 StopRecordViewController
        performSegue(withIdentifier: "mainToStopRecord", sender: self.currentRecordingPathId)
    }
    
    func downloadMap() {
        // 改变样式
        downloadDone.isHidden   = false
        mainButton.isHidden     = true
    }
    
    // 打点并且跳到添加打点内容的页面
    @IBAction func pinDrop(_ sender: UIButton) {
        let userCurrentLocation = mapView.userLocation!
        print("userCurrentLocation 的值是\(userCurrentLocation)")
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: userCurrentLocation.coordinate.latitude, longitude: userCurrentLocation.coordinate.longitude)
        mapView.addAnnotation(point)
        
        // 传递 userCurrentLocation 值，给PinDropViewController
        performSegue(withIdentifier: "mainToPinDrop", sender: self)
    }
    
    // 改变打点图片
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "pointOnPath")
        if annotationImage == nil {
            var image = UIImage(named: "pointOnPath")!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            image = image.resize(toHeight: 25)!
            image = image.resize(toWidth: 25)!
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pointOnPath")
        }
        
        return annotationImage
    }

    // 侧边栏样式
    func setSideMenuStyle() {
        SideMenuManager.menuAnimationTransformScaleFactor = CGFloat(1)
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuWidth = view.frame.width * CGFloat(0.78)
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

extension MainViewController : SearchingTextDelegate {
    public func setupMask() {
        mask = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        mask!.frame = self.view.bounds
        mask!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mask!.alpha = 0
        mask!.isUserInteractionEnabled = true
        self.view.insertSubview(mask!, at: 5)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func searchingTextFieldActive() {
        self.searchSelections.alpha = 0
        self.searchSelections.isHidden = false
        self.setupMask()
        UIView.animate(withDuration: 0.3, animations: {
            self.searchSelections.alpha = 1
            self.mask?.alpha = 1
        })
    }
    
    func exitEditMode(_ sender: Any?) {
        UIApplication.shared.keyWindow?.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.searchSelections.alpha = 0
            self.mask?.alpha = 0
        })
        self.mask?.removeFromSuperview()
        self.mask = nil
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("PurupuruPAPA~~~~~~")
        textField.endEditing(true)
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        exitEditMode(textField)
    }
    
    
}
