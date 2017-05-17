//
//  SideMenuButton.swift
//  LittlePajero
//
//  Created by Cassius Chen on 2017/5/17.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import Material

class SideMenuButton: FlatButton {
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customStyle()
    }*/
    
    private func customStyle() {
        imageView?.frame = CGRect(x: 20, y: 19, width: 20, height: 20)
        imageView?.contentMode = UIViewContentMode.center
        
        let titleLableWidth = self.bounds.size.width - 54 - 20
        titleLabel?.frame = CGRect(x: 54, y: 16, width: titleLableWidth, height: 25)
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        titleLabel?.textColor = UIColor.lpBlack
        titleLabel?.textAlignment = NSTextAlignment.left
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.customStyle()
    }
}
