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

class StopRecordViewController: UIViewController, MGLMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var mainVC : MainViewController?
    var currentPathId: Int = 0
    
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var pointsTableView: UITableView!
    
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
        
        // 地图中心先设置成用户 —— 之后要自定义中心
        mapView.userTrackingMode = .follow
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
    
    

    // UITableViewDelegate 和 UITableViewDataSource delegate 的方法
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
}
