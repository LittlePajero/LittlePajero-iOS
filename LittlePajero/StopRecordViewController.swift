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
    
    // 定义屏幕高度 —— 滚动需要
    let screenHeight = UIScreen.main.bounds.height
    // 定义滚动内容物高度 —— 滚动需要
    let scrollViewContentHeight = 740 as CGFloat
    let scrollViewContentWidth = 375 as CGFloat
    
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
        
        // mapView 的代理是自己
        mapView.delegate = self
        pointsTableView.delegate = self
        pointsTableView.dataSource = self
        scrollView.delegate = self
        
        // 地图中心先设置成用户 —— 之后要自定义中心
        mapView.userTrackingMode = .follow
        
        scrollView.contentSize = CGSize(width: scrollViewContentWidth, height: scrollViewContentHeight)
        scrollView.bounces = false
        pointsTableView.bounces = false
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
    
    // 添加 Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        return headerCell
    }
    
    // 添加 Header 高度（不能删，没有他显示不出来，我也不知道为什么）
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    // 添加 Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! FooterTableViewCell
        return footerCell
    }
    
    // 添加 Footer 高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 192.0
    }

    //----- UITableViewDelegate 和 UITableViewDataSource delegate 的方法 --------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowInSection")
        let currentPath = realm.object(ofType: RealmPath.self, forPrimaryKey: currentPathId)
        let points = currentPath?.points
        return points!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointTableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // ---------------------------------------------------------------------------
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if scrollView == self.scrollView {
            if yOffset >= scrollViewContentHeight - screenHeight {
                scrollView.isScrollEnabled = false
                pointsTableView.isScrollEnabled = true
            }
        }
        
        if scrollView == self.pointsTableView {
            if yOffset <= 0 {
                self.scrollView.isScrollEnabled = true
                self.pointsTableView.isScrollEnabled = false
            }
        }
    }
}
