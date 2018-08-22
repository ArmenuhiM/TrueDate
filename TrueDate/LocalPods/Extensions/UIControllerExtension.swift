//
//  UIControllerExtension.swift
//  TrueDate
//
//  Created by Armenuhi on 9/16/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

extension UIViewController {
  
    func getViewControllerWithStoryBoard(sbName: String, vcIndentifier: String) -> UIViewController? {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: vcIndentifier)
        return vc
    }
    
    func getInitialViewController(sbName: String) -> UIViewController? {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateInitialViewController()
        return vc
    }
}
