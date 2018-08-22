//
//  SettingsTableViewCell.swift
//  TrueDate
//
//  Created by Armenuhi on 12/5/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class DistanceSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceData: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
