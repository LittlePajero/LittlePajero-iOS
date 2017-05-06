//
//  ViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/5.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import Mapbox      // 引入超级好用的地图

class ViewController: UIViewController {

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var subButtonOne: UIButton!
    @IBOutlet weak var subButtonTwo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // 设置地图中心为用户坐标
        mapView.userTrackingMode = .follow
        
        // 设置 MainButton 的样式
        setMainButtonStyle()
        
        // 设置 SubButtons 的样式
        setSubButtonStyle()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 设置 MainButton 的 style
    func setMainButtonStyle() {
        mainButton.layer.cornerRadius = mainButton.bounds.size.height / 2
        mainButton.layer.borderWidth = 3.0
        mainButton.layer.borderColor = UIColor.white.cgColor
    }
    
    // 设置 SubButton 的样式
    func setSubButtonStyle() {
        subButtonOne.layer.backgroundColor = UIColor.gray.cgColor
        subButtonOne.layer.cornerRadius = subButtonOne.bounds.size.height / 2
        subButtonOne.setTitleColor(.white, for: .normal)
    
        subButtonTwo.layer.backgroundColor = UIColor.gray.cgColor
        subButtonTwo.layer.cornerRadius = subButtonOne.bounds.size.height / 2
        subButtonTwo.setTitleColor(.white, for: .normal)
    }

}

