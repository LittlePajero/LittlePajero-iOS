//
//  PinDropViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/14.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit

class PinDropViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationKindTextFeild: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraButtonLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
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
        locationKindTextFeild.textColor = UIColor.lpWhite
        commentTextView.textColor = UIColor.lpWhite
        
        // 设置默认 TextView 里面的 placeholder
        commentTextView.text = "备注"
        commentTextView.textColor = UIColor.lpGrey
        
        // 从 MainViewController 传 location 到这个页面
        locationLabel.text = "\(location)"
        
        //locationKindTextFeild.placeHolderColor = UIColor.lpGrey
        
        locationKindTextFeild.delegate = self
        commentTextView.delegate = self
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
    
    // 按回车之后收起键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // 用户开始输入之后，去掉框框里的内容
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lpGrey {
            textView.text = nil
            textView.textColor = UIColor.lpWhite
        }
    }
    
    // 用户要是删掉了内容的话，把 placeholder 内容放回来
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "备注"
        }
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
