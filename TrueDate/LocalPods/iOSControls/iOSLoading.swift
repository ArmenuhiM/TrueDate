//
//  iOSLoading.swift
//  TrueDate
//
//  Created by Armenuhi on 9/12/17.
//  Copyright © 2017 Company. All rights reserved.
//


import UIKit

final class JMLoading: NSObject {
    static let sharedInstance = JMLoading()
    var activityIndicator:UIActivityIndicatorView?
    
    func getActivityIndicatorView() -> UIActivityIndicatorView? {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            activityIndicator?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            activityIndicator?.hidesWhenStopped = true
            DispatchQueue.main.async {
                self.activityIndicator?.frame = (UIApplication.shared.keyWindow?.frame)!
                UIApplication.shared.keyWindow?.addSubview(self.activityIndicator!)
            }
        }
        UIApplication.shared.keyWindow?.bringSubview(toFront: activityIndicator!)
        return activityIndicator
    }
    
    func showActivityIndicator() {
        getActivityIndicatorView()?.startAnimating();
    }
    
    func hideActivityIndicator() {
        getActivityIndicatorView()?.stopAnimating();
    }
}


