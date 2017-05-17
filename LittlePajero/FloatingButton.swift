//
//  FloatingGreyButton.swift
//  LittlePajero
//
//  Created by Cassius Chen on 2017/5/14.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import Foundation
import UIKit
import Material


class FloatingButton : FABButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customStyle()
    }
    
    private func customStyle() {
        self.backgroundColor = UIColor.lpBackgroundWhite
        self.tintColor = UIColor.lpGrey
        //self.inkColor = UIColor.lpInkOnWhite
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 0
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1
    }
    
    private func subViewsLayout() {
        let imageWidth : CGFloat = 28
        let imagePosition = ((self.bounds.size.width - imageWidth)/2, (self.bounds.size.height - imageWidth)/2)
        self.imageView?.frame = CGRect(x: imagePosition.0, y: imagePosition.1, width: imageWidth, height: imageWidth)
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        self.titleLabel?.textColor = UIColor.lpBlack
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel?.frame = CGRect(x: 0, y: self.bounds.size.height + 8, width: self.bounds.size.width, height: 22)
        self.titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subViewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.customStyle()
    }
}
