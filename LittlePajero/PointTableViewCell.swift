//
//  PointTableViewCell.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/24.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit

class PointTableViewCell: UITableViewCell {

    // Mark: Properties
    @IBOutlet weak var pointName: UILabel!
    @IBOutlet weak var pointLocation: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // 样式
        pointName.textColor = UIColor.lpBlack
        pointLocation.textColor = UIColor.lpGrey
        commentLabel.textColor = UIColor.lpGrey
        photoImageView.layer.cornerRadius = photoImageView.layer.bounds.height / 2
        self.backgroundColor = UIColor.lpBackgroundWhite
        self.photoImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
