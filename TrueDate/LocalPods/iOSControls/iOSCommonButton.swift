//
//  iOSCommonButton.swift
//  TrueDate
//
//  Created by Armenuhi on 9/16/17.
//  Copyright © 2017 Company. All rights reserved.
//


import UIKit

class iOSCommonButton: UIButton {
    
    override func awakeFromNib() {
        configureButton()
    }
    
    func configureButton(){
        self.layer.cornerRadius = 9
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.titleLabel?.minimumScaleFactor = 0.6;
        self.titleLabel?.adjustsFontSizeToFitWidth = true;
        let fontName = self.titleLabel?.font.fontName
        let fontSize = 1.5 * (self.titleLabel?.font.pointSize)!
        
        if  UIDevice.current.userInterfaceIdiom == .pad {
            self.layer.cornerRadius = 10;
            self.titleLabel?.font = UIFont(name: fontName!, size: fontSize)
        }
    }
    deinit {
    }
}
