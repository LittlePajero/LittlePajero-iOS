//
//  SearchingBarControlButton.swift
//  LittlePajero
//
//  Created by Cassius Chen on 2017/5/15.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class SearchingBarControlButton: MDCFlatButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customStyle()
    }
    
    private func customStyle() {
        // 背景颜色
        self.backgroundColor = UIColor.lpBackgroundWhite
    }
    
    private func setMenuButtonStyle() {
        self.imageView?.frame = CGRect(x: 16, y: 16, width: 18, height: 12)
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
