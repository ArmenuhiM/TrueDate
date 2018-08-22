//
//  iOSImageView.swift
//  TrueDate
//
//  Created by Armenuhi on 9/16/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class iOSImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func circledImageView(){
        layer.cornerRadius = frame.size.width / 2
        backgroundColor = UIColor.paLightGrayColor
        layer.masksToBounds = true
        //layer.borderWidth = 2
       // layer.borderColor = UIColor.paGrayColor.cgColor
        clipsToBounds = true
    }

    override func layoutSubviews() {
        circledImageView()
    }
    
    deinit {
        print("PAImageView deinit")
    }
}
