//
//  SearchingBar.swift
//  LittlePajero
//
//  Created by Cassius Chen on 2017/5/15.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit

class SearchingBar: UIView {
    public var textFieldDelegate : SearchingTextDelegate? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customStyle()
        self.listenTextFieldTouched()
    }
    
    private func customStyle() {
        // 背景颜色
        self.backgroundColor = UIColor.lpBackgroundWhite
        
        // 圆角
        self.layer.cornerRadius = 2
        
        // 阴影
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1
    }
    
    private func setMenuButtonStyle() {
        let button = self.viewWithTag(1) as! UIButton
        button.imageView?.frame = CGRect(x: 14, y: 17, width: 18, height: 12)
    }
    
    func touchEventHandler(_ textField: SearchingBarTextField) {
        textFieldDelegate?.searchingTextFieldActive()
    }
    
    private func listenTextFieldTouched() {
        let textField = self.viewWithTag(2) as! SearchingBarTextField
        textField.addTarget(self, action: #selector(SearchingBar.touchEventHandler(_:)), for: UIControlEvents.editingDidBegin)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setMenuButtonStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customStyle()
        self.listenTextFieldTouched()
    }
}
