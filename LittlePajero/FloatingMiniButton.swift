//
//  FloatingGreyButton.swift
//  LittlePajero
//
//  Created by Cassius Chen on 2017/5/14.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialButtons

class FloatingMiniButton : MDCRaisedButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customStyle()
    }
    
    private func customStyle() {
        self.backgroundColor = UIColor.lpBackgroundWhite
        self.tintColor = UIColor.lpGrey
        self.inkColor = UIColor.lpInkOnWhite
        self.layer.cornerRadius = 2
        
        
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 6, y: 6, width: 18, height: 18)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.customStyle()
    }
}
