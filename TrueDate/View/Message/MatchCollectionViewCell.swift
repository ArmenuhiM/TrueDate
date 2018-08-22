//
//  MatchCell.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/12.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit

class MatchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var notifyNewMatch: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
