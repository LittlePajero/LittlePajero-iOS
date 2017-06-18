//
//  RatingButton.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/25.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import Foundation
import UIKit
import Material
import Realm

class RatingButton : FlatButton {
    
    var alternateButtons: [RatingButton]?
    var selectedButtonTitle: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customStyle()
    }
    
    private func customStyle() {
        self.layer.cornerRadius = self.layer.height / 2
        //self.backgroundColor = UIColor.lpWhite
        //self.tintColor = UIColor.lpGrey
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customStyle()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = UIColor.lpOrange
                self.tintColor = UIColor.lpOrange
                self.titleColor = UIColor.lpWhite
                self.pulseColor = UIColor.lpOrange
            } else {
                self.backgroundColor = UIColor.lpWhite
                self.tintColor = UIColor.lpWhite
                self.titleColor = UIColor.lpGrey
                self.pulseColor = UIColor.lpGrey
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if alternateButtons != nil {
            self.isSelected = true
            
            for button: RatingButton in alternateButtons! {
                button.isSelected = false
            }
        } else {
            toggleButton()
        }
        selectedButtonTitle = self.titleLabel?.text
        print("点击了按钮：\(selectedButtonTitle!)")
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    
}
