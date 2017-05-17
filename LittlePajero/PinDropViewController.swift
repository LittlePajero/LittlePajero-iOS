//
//  PinDropViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/14.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit

class PinDropViewController: UIViewController {
    
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationKindTextFeild: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraButtonLabel: UILabel!
    
    var location: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 将背景设置为模糊
        setBackgroundBlur()
        
        locationLabel.textColor = UIColor.lpBackgroundWhite
        locationLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        desLabel.textColor = UIColor.lpBackgroundWhite
        cameraButton.backgroundColor = UIColor.lpGrey
        cameraButtonLabel.textColor = UIColor.lpMuteBlack
        // 从 MainViewController 传 location 到这个页面
        locationLabel.text = "\(location)"
        
        //locationKindTextFeild.placeHolderColor = UIColor.lpGrey
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 设置背景为模糊
    func setBackgroundBlur() {
        
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
