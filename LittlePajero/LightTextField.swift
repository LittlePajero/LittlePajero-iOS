//
//  LightTextField.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/17.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import Material

class LightTextField : TextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        custom()
    }
    
    func custom() {
        self.placeholderNormalColor = UIColor.lpGrey
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom()
    }
}
