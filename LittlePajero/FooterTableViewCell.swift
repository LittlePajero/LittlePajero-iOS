//
//  FooterTableViewCell.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/25.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit

class FooterTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var CButton: RatingButton!
    @IBOutlet weak var BButton: RatingButton!
    @IBOutlet weak var AButton: RatingButton!
    @IBOutlet weak var SButton: RatingButton!
    @IBOutlet weak var EButton: RatingButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.textColor = UIColor.lpBlack
        self.backgroundColor = UIColor.lpBackgroundWhite
        
        CButton.isSelected = false
        BButton.isSelected = false
        AButton.isSelected = false
        SButton.isSelected = false
        EButton.isSelected = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
