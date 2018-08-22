//
//  iOSCommonNavigationController.swift
//  ShowUp
//
//  Created by Armenuhi on 11/1/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class iOSCommonNavigationController: UINavigationController {

   //MARK: - View Life Cycle
        override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.mainColor
        self.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Roboto-Medium", size: 18)!, NSForegroundColorAttributeName : UIColor.white]
        self.navigationBar.tintColor = UIColor.white
        
        let yourBackImage = UIImage(named: "navigationBack")
        navigationBar.backIndicatorImage = yourBackImage
        navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
