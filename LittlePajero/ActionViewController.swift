//
//  ActionViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/9.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 将背景设置为模糊
        setBackgroundBlur()
        
        // 将这个页面上 3 个按钮的样式设置好
        setButtonToCircle(closeButton)
        setButtonToCircle(recordButton)
        setButtonToCircle(cameraButton)
        
        // 设置按钮文字样式
        setLabelStyle()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 关闭按钮 关闭页面
    @IBAction func close() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // 设置按钮的样式
    func setButtonToCircle(_ button: UIButton) {
        button.layer.backgroundColor = UIColor.white.cgColor
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
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.insertSubview(blurEffectView, at: 0)
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
