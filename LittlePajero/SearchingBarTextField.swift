//
//  SearchingBarControlButton.swift
//  LittlePajero
//
//  Created by Cassius Chen on 2017/5/15.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit

class SearchingBarTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customStyle()
    }
    
    private func customStyle() {
        self.backgroundColor = UIColor.lpBackgroundWhite
        self.borderStyle = UITextBorderStyle.none
        self.clearButtonMode = UITextFieldViewMode.whileEditing
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        self.leftView = leftPadding
        self.leftViewMode = UITextFieldViewMode.always
        
        self.layer.cornerRadius = 2
        
        let clearButton = self.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(#imageLiteral(resourceName: "clear"), for: UIControlState.normal)
        clearButton.setImage(#imageLiteral(resourceName: "clear"), for: UIControlState.highlighted)
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customStyle()
    }
}
