//
//  UIAlertViewControllerExtention.swift
//  TrueDate
//
//  Created by Armenuhi on 9/16/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: AlertView
    
    func showAlertView(_ title:String? , message: String?, completion:((_ finish:Bool)->Void)?) -> Void {
        let _self = self;
        
        let alertView = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.cancel,
                                          handler: {(alert: UIAlertAction!) in
                                            if completion != nil {
                                                completion!(true)
                                            }
        }))
        
        _self.present(alertView, animated: true, completion: nil)
    }
    
    
    func showAlertViewController(_ title:String? , message: String?, otherButtonTitles :[String], cancelButtonTitle:String?, destructiveButtonTitle: String?, actionHandler :((_ action: String)->Void)? )-> Void {
        
        let _self = self;
        
        let alertView = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        
        if !otherButtonTitles.isEmpty {
            for otherButtonTitle in otherButtonTitles {
                alertView.addAction(UIAlertAction(title: otherButtonTitle,style: UIAlertActionStyle.default,                handler: {(alert: UIAlertAction!) in
                    actionHandler!(otherButtonTitle)
                    print(otherButtonTitle)
                    alertView.dismiss(animated: true, completion: nil)
                }))
            }
            
        }
        
        if cancelButtonTitle != nil {
            alertView.addAction(UIAlertAction(title: cancelButtonTitle,style: UIAlertActionStyle.cancel,                handler: {(alert: UIAlertAction!) in
                alertView.dismiss(animated: true, completion: nil)
                //                print(cancelButtonTitle)
            }))
        }
        
        if destructiveButtonTitle != nil {
            alertView.addAction(UIAlertAction(title: destructiveButtonTitle,style: UIAlertActionStyle.destructive,
                                              handler: {(alert: UIAlertAction!) in
                                                actionHandler!(destructiveButtonTitle!)
                                                alertView.dismiss(animated: true, completion: nil)
                                                //                print(destructiveButtonTitle)
            }))
        }
        _self.present(alertView, animated: true, completion: nil)
    }
    
    func showActionSheetInController(_ sender:UIView, title:String? , message: String?, otherButtonTitles :[String], cancelButtonTitle:String?, destructiveButtonTitle: String?, actionHandler :((_ action: String)->Void)? )-> Void {
        
        let _self = self;
        
        let alertView = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if !otherButtonTitles.isEmpty {
            for otherButtonTitle in otherButtonTitles {
                alertView.addAction(UIAlertAction(title: otherButtonTitle,style: UIAlertActionStyle.default,                handler: {(alert: UIAlertAction!) in
                    actionHandler!(otherButtonTitle)
                    print(otherButtonTitle)
                    alertView.dismiss(animated: true, completion: nil)
                }))
            }
        }
        
        if cancelButtonTitle != nil {
            alertView.addAction(UIAlertAction(title: cancelButtonTitle,style: UIAlertActionStyle.cancel,                handler: {(alert: UIAlertAction!) in
                //                actionHandler!(action: cancelButtonTitle!)
                alertView.dismiss(animated: true, completion: nil)
            }))
        }
        
        if destructiveButtonTitle != nil {
            alertView.addAction(UIAlertAction(title: destructiveButtonTitle,style: UIAlertActionStyle.destructive,                handler: {(alert: UIAlertAction!) in
                alertView.dismiss(animated: true, completion: nil)
            }))
        }
        
        if ( UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ) {
            
            if let currentPopoverpresentioncontroller = alertView.popoverPresentationController {
                currentPopoverpresentioncontroller.sourceView = sender
                currentPopoverpresentioncontroller.sourceRect = sender.bounds;
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.any;
                _self.present(alertView, animated: true, completion: nil)
            }
        } else {
            _self.present(alertView, animated: true, completion: nil)
        }
    }

}
