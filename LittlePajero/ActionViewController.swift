//
//  ActionViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/9.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import Hero

class ActionViewController: UIViewController {
    
    var mainVC : MainViewController?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 将背景设置为模糊
        setBackgroundBlur()
        
        // 设置按钮文字样式
        setLabelStyle()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 关闭按钮 关闭页面
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startRecordPath(_ sender: UIButton) {
        //self.delegate?.sendMode(mode: "RecordPath")
        self.mainVC?.mode = .recording
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // 设置按钮的样式
    func setButtonToCircle(_ button: UIButton) {
        button.layer.backgroundColor = UIColor.lpBackgroundWhite.cgColor
        button.layer.cornerRadius = button.bounds.size.height / 2
    }
    
    // 设置按钮文字样式
    func setLabelStyle() {
        recordLabel.textColor = UIColor.white
        cameraLabel.textColor = UIColor.white
    }
    
    // 设置背景为模糊
    func setBackgroundBlur() {
        self.view.backgroundColor = UIColor.clear
        
        //mainVC?.setupMask()
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        self.view.insertSubview(blurEffectView, at: 0)
        
        blurEffectView.heroModifiers = [.fade]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
