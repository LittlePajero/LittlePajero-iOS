//
//  StopViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/17.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import Mapbox
import RealmSwift

class StopRecordViewController: UIViewController, MGLMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var mainVC : MainViewController?
    var currentPathId: Int = 0
    
    // 定义屏幕高度和宽度 —— 滚动需要
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    // 导航栏高度 64
    let navigationHeight: CGFloat = 64.0
    let headerHeight: CGFloat = 100.0
    let footerHeight: CGFloat = 200.0
    
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var pointsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置 navigationBar 上的按钮
        let backButton = UIBarButtonItem(image: UIImage(named: "arrowBackMaterial"), style: .plain, target: self, action: #selector(StopRecordViewController.backToMainVC))
        let moreButton = UIBarButtonItem(image: UIImage(named: "moreVertMaterial"), style: .plain, target: self, action: #selector(StopRecordViewController.clickMoreButton))
        let shareButton = UIBarButtonItem(image: UIImage(named: "shareMaterial"), style: .plain, target: self, action: #selector(StopRecordViewController.clickShareButton))
        
        // 将按钮添加到 navigationBar 上
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.setLeftBarButton(backButton, animated: true)
        navigationItem.setRightBarButtonItems([moreButton, shareButton], animated: true)
        
        // 设置 navigationBar 上的图标颜色是白色
        self.navigationController?.navigationBar.tintColor = UIColor.lpWhite
        
        // mapView 的代理是自己
        mapView.delegate = self
        pointsTableView.delegate = self
        pointsTableView.dataSource = self
        scrollView.delegate = self
        
        // 地图中心先设置成用户 —— 之后要自定义中心
        mapView.userTrackingMode = .follow
        
        let currentPath = realm.object(ofType: RealmPath.self, forPrimaryKey: currentPathId)
        let points = currentPath?.points
        
        // 计算 scrollViewContentSize = tableViewTables + screenHeight + 一个不知道是什么的值
        let scrollViewContentHeight = 132 + CGFloat((points?.count)! * 95) + screenHeight
        // 确定 scrollView 的宽度和高度
        scrollView.contentSize = CGSize(width: screenWidth, height: scrollViewContentHeight)
        // scrollView 弹性
        scrollView.bounces = true
        // 隐藏滚动条
        scrollView.showsVerticalScrollIndicator = false
        
        // TableView 的高度根据内容变化
        pointsTableView.sizeToFit()
        // 固定 TableView 的位置
        pointsTableView.frame = CGRect(x: 0, y: screenHeight - 300, width: screenWidth, height: (CGFloat(300 + (points?.count)! * 95)))
        
        // 隐藏 navigationBar，颜色设置为白色
        let transparentBackground = UIImage.imageWithColor(tintColor: UIColor.lptransparent)
        self.navigationController?.navigationBar.setBackgroundImage(transparentBackground, for: .default)
        //self.navigationController?.navigationBar.setBackgroundImage(whiteBackground, for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.alpha = 1
        //self.navigationController?.navigationBar.isTranslucent = true
        
        //self.navigationController?.navigationBar.barTintColor = UIColor.lpBackgroundWhite.withAlphaComponent(1)
        
        print("ScreenHeihgt: \(screenHeight)")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 点击按钮返回
    func backToMainVC() {
        self.mainVC?.mode = .idle
        self.dismiss(animated: true, completion: nil)
    }
    
    func clickMoreButton() {
        
    }
    
    func clickShareButton() {
        
    }
    
    @IBAction func clickSaveButton() {
        
       // self.dismiss(animated: true, completion: nil)
    }
    
    // 添加 Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        // 记录时间
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        //时间给标题
        headerCell.nameLabel.text = "\(year)年\(month)月\(day)日 \(hour):\(minute)的穿越"
        headerCell.timeLabel.text = "\(year)年\(month)月\(day)日"
        return headerCell
    }
    
    // 添加 Header 高度（不能删，没有他显示不出来，我也不知道为什么）
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    // 添加 Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! FooterTableViewCell
        footerCell.CButton?.alternateButtons = [footerCell.BButton!, footerCell.AButton!, footerCell.SButton!, footerCell.EButton!]
        footerCell.BButton?.alternateButtons = [footerCell.CButton!, footerCell.AButton!, footerCell.SButton!, footerCell.EButton!]
        footerCell.AButton?.alternateButtons = [footerCell.CButton!, footerCell.BButton!, footerCell.SButton!, footerCell.EButton!]
        footerCell.SButton?.alternateButtons = [footerCell.CButton!, footerCell.BButton!, footerCell.AButton!, footerCell.EButton!]
        footerCell.EButton?.alternateButtons = [footerCell.CButton!, footerCell.BButton!, footerCell.AButton!, footerCell.SButton!]
        return footerCell
    }
    
    // 添加 Footer 高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 200.0
    }

    //----- UITableViewDelegate 和 UITableViewDataSource delegate 的方法 --------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowInSection")
        let currentPath = realm.object(ofType: RealmPath.self, forPrimaryKey: currentPathId)
        let points = currentPath?.points
        return points!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointTableViewCell") as! PointTableViewCell
        let currentPath = realm.object(ofType: RealmPath.self, forPrimaryKey: currentPathId)
        let pointList = (currentPath?.points[indexPath.row])!
        cell.pointName.text = pointList.kind
        cell.pointLocation.text = "\(String(describing: pointList.latitude)), \(String(describing: pointList.longitude))"
        cell.commentLabel.text = pointList.comment
        if pointList.photo == nil {
            cell.photoImageView.image = UIImage(named: "photoMaterial")
        } else {
            cell.photoImageView.image = UIImage(data: pointList.photo! as Data, scale: 1.0)
        }
        // 取消 cell 选中
        cell.selectionStyle = .none
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    */
    
    // ---------------------------------------------------------------------------
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewPosition = screenHeight - (headerHeight + footerHeight) - scrollView.contentOffset.y
        print("navigationBarAlpha: \(self.navigationController?.navigationBar.alpha)")
        if (scrollViewPosition <= navigationHeight && scrollViewPosition > 32) {
            let navigationAlpha = (navigationHeight - scrollViewPosition) / 32
            let whiteBackground = UIImage.imageWithColor(tintColor: UIColor.lpBackgroundWhite.withAlphaComponent(navigationAlpha))
            self.navigationController?.navigationBar.setBackgroundImage(whiteBackground, for: .default)
            self.navigationController?.navigationBar.tintColor = UIColor.lpBlack
            // 设置 Status Bar 为深色
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            print("alpha: \(navigationAlpha)")
        } else if (scrollViewPosition <= 32) {
            self.navigationController?.navigationBar.barTintColor = UIColor.lpBackgroundWhite.withAlphaComponent(1)
            self.navigationController?.navigationBar.alpha = 1
            self.navigationController?.navigationBar.tintColor = UIColor.lpBlack
        } else if (scrollViewPosition > navigationHeight) {
            let transparentBackground = UIImage.imageWithColor(tintColor: UIColor.lptransparent)
            self.navigationController?.navigationBar.setBackgroundImage(transparentBackground, for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.lpWhite
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // print("滑动方向：\(velocity.y)")
        //if (velocity.y > 0) {
        //    self.navigationController?.setNavigationBarHidden(true, animated: true)
        //} else {
        //    self.navigationController?.setNavigationBarHidden(false, animated: false)
        //}
        let scrollViewPosition = screenHeight - (headerHeight + footerHeight) - scrollView.contentOffset.y
        if (scrollViewPosition <= navigationHeight && scrollViewPosition > 32) {
            let navigationAlpha = (navigationHeight - scrollViewPosition) / 32
            let whiteBackground = UIImage.imageWithColor(tintColor: UIColor.lpBackgroundWhite.withAlphaComponent(navigationAlpha))
            self.navigationController?.navigationBar.setBackgroundImage(whiteBackground, for: .default)
            self.navigationController?.navigationBar.tintColor = UIColor.lpBlack
        } else if (scrollViewPosition <= 32) {
            self.navigationController?.navigationBar.barTintColor = UIColor.lpBackgroundWhite
            self.navigationController?.navigationBar.alpha = 1
            self.navigationController?.navigationBar.tintColor = UIColor.lpBlack
        } else if (scrollViewPosition > navigationHeight) {
            let transparentBackground = UIImage.imageWithColor(tintColor: UIColor.lptransparent)
            self.navigationController?.navigationBar.setBackgroundImage(transparentBackground, for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.lpWhite
            
        }
    }
}

extension UIImage {
    static func imageWithColor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
