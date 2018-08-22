//
//  iOSCommonNavigationController.swift
//  TrueDate
//
//  Created by Armenuhi on 9/12/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class iOSCommonNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.isTranslucent = false
            // Bar color
            self.navigationBar.barTintColor = UIColor.paLightGrayColor
            self.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.grayTitleColor]
            // Bar buttons color
            self.navigationBar.tintColor = UIColor.barButtonTitleColor

            let yourBackImage = UIImage(named: "back")
            navigationBar.backIndicatorImage = yourBackImage
            navigationBar.backIndicatorTransitionMaskImage = yourBackImage
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
