//
//  ViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/5.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import Mapbox      // 引入超级好用的地图

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator() as UIViewControllerAnimatedTransitioning
    }
}

class ViewController: UIViewController {

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var mainButton: UIButton!           // 中间大按钮
    @IBOutlet weak var subButtonOne: UIButton!         // 侧边按钮
    @IBOutlet weak var subButtonTwo: UIButton!         // 侧边按钮
    @IBOutlet weak var searchBox: UISearchBar!         // 搜索框
    
    // 两个会弹出的按钮(不知道功能所以名称暂定)
    @IBOutlet weak var BT1: UIButton!
    @IBOutlet weak var BT2: UIButton!
    
    // 设置两个弹出按钮的初始位置
    var BT1Center: CGPoint!
    var BT2Center: CGPoint!
    
    @IBAction func openMenu(sender: AnyObject) {
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuViewController {
            destinationViewController.transitioningDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // 设置地图中心为用户坐标
        mapView.userTrackingMode = .follow
        
        // 设置 MainButton 的样式
        setMainButtonStyle()
        
        // 设置 SubButtons 的样式(左侧两个小按钮)
        setSubButtonStyle()
        
        searchBox.barTintColor = UIColor.white
        
        setBTStyle()
        // 记录弹出按钮的初始位置
        BT1Center = BT1.center
        BT2Center = BT2.center
        
        // 让两个按钮放在 mainButton 的后面
        BT1.center = mainButton.center
        BT2.center = mainButton.center
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
    
    // 设置 BT1 BT2 的样式
    func setBTStyle() {
        BT1.layer.cornerRadius = BT1.bounds.size.height / 2
        BT2.layer.cornerRadius = BT2.bounds.size.height / 2
    }
    
    // 按 MainButton 之后弹出或者收回两个按钮
    @IBAction func mainButtonClicked(_ sender: UIButton) {
        
        if mainButton.currentImage == #imageLiteral(resourceName: "symbol") {
            // expand buttons
            UIView.animate(withDuration: 0.3, animations: {
                // animations here
                self.BT1.center = self.BT1Center
                self.BT2.center = self.BT2Center
            })
        } else {
            // collapse buttons
            UIView.animate(withDuration: 0.3, animations: {
                self.BT1.center = self.mainButton.center
                self.BT2.center = self.mainButton.center
            })
        }

        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "symbol"), offImage: #imageLiteral(resourceName: "symbol_close"))
    }
    
    // 按钮点击变叉子
    func toggleButton(button: UIButton, onImage: UIImage, offImage: UIImage) {
        if button.currentImage == onImage {
            button.setImage(offImage, for: .normal)
        } else {
            button.setImage(onImage, for: .normal)
        }
    }
}

