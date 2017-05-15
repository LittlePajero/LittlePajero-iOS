//
//  SearchingBar.swift
//  LittlePajero
//
//  Created by Cassius Chen on 2017/5/15.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit

class SearchingBar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customStyle()
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
        debugPrint(self.subviews)
        let button = self.viewWithTag(1) as! UIButton
        button.imageView?.frame = CGRect(x: 14, y: 17, width: 18, height: 12)
        print("This one fired")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setMenuButtonStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customStyle()
    }
}
