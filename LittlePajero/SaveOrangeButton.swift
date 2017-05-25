//
//  SaveOrangeButton.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/25.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import Foundation
import UIKit
import Material

class SaveOrangeButton : RaisedButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customStyle()
    }
    
    private func customStyle() {
        self.backgroundColor = UIColor.lpOrange
        self.tintColor = UIColor.lpBackgroundWhite
        self.layer.cornerRadius = 6
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customStyle()
    }
}
