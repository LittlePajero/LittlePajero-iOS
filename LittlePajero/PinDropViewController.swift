//
//  PinDropViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/14.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import Mapbox

class PinDropViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationKindTextFeild: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraButtonLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var locationKindPickerView: UIPickerView! = UIPickerView()
    
    var location: MGLUserLocation!
    var pathId: Int = 0
    let locationKind = ["行程起点", "下道点", "转折点", "露营点", "上道点", "行程终点", "其他"]

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
        locationLabel.text = String(format: "%0.5f°, %0.5f°", (location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
        
        // Delegate 都放在了这里
        locationKindTextFeild.delegate = self
        commentTextView.delegate = self
        locationKindPickerView.delegate = self
        locationKindPickerView.dataSource = self
        
        // 将 UITextField 原先的键盘换成 UIPickerView
        locationKindTextFeild.inputView = locationKindPickerView
        
        // 不能把 locationKindPickerView 添加进 Subview , 否则会报错
        self.locationKindPickerView.removeFromSuperview()
        
        // 设置 UItextField 预设内容
        // locationKindTextFeild.text = locationKind[0]
        
        // 增加触控事件(点击空白处收起 PickerView)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(PinDropViewController.hidePickerView(tapG:)))
        tap.cancelsTouchesInView = false
        
        // 在最底层的 View 上加上点击事件
        self.view.addGestureRecognizer(tap)
        
        print("pathId 是：\(pathId)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 点击空白处收起 PickerView
    func hidePickerView(tapG: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
    
    // 保存内容
    @IBAction func save() {
        let realm = try! Realm()
        // 设置 Point
        let point = RealmPoint()
            // 获得 用户坐标
        point.latitude = Float(location.coordinate.latitude)
        point.longitude = Float(location.coordinate.longitude)
            // 获得坐标 ID
        point.id = RealmPoint.incrementID()
            // 获得 坐标类型
        if locationLabel.text != "" {
            point.kind = locationLabel.text!
        } else {
            point.kind = "快快添加上坐标类型吧～"
        }
        // 获得 备注
        if commentTextView.text != "备注" {
            point.comment = commentTextView.text!
        } else {
            point.comment = "快快添加上坐标备注吧～"
        }
        // 获得当前 path
        let path = realm.object(ofType: RealmPath.self, forPrimaryKey: self.pathId)
        // 都获得之后就可以保存了！
        try! realm.write {
            realm.add(point)
            path?.points.append(point)
        }
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
    
    // ------------ UIPickerView Delegate 方法 ----------------------------
    // UIPickerView 有几列可以选择
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerView 各列有多少行资料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationKind.count
    }
    
    // UIPickerView 每个选项提示的资料
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationKind[row]
    }
    
    // UIPickerView 改变选项后执行的操作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let textField = self.view?.viewWithTag(100) as? UITextField
        textField?.text = " " + locationKind[row]
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
