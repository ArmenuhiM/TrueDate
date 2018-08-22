//
//  DetailViewController.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/22.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import Alamofire
import ImageSlideshow

class ProfileDetailViewController: UIViewController {
  
    var networkStatus: Bool!
    var profileInfo = [String]()
    var userImageInfo = [String]()
    @IBOutlet var slideshow: ImageSlideshow!
    
    var alamofireSource = [AlamofireSource]()

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var introduction: UILabel!

    @IBOutlet weak var distanceLabel: UILabel!
    class func instantiateFromStoryboard() -> ProfileDetailViewController {
        let storyboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! ProfileDetailViewController
    }
    
    
    // MARK: - Reachability
    func updateUserInterface() -> Bool {
        guard let status = Network.reachability?.status else { return networkStatus }
        switch status {
        case .unreachable:
            networkStatus = false
        case .wifi:
            networkStatus = true
        case .wwan:
            networkStatus = true
        }
        
        return networkStatus
    }
    
    
    func statusManager(_ notification: NSNotification) {
        let result = updateUserInterface()
        if result == true {
            print("True", true)
        }else {
            print("False", false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        
        // Check Internet connection
        let result = updateUserInterface()
        if result == true {
            name.text = "\((profileInfo[0]))"
            
            if (profileInfo[1]) != "" {
                introduction.text = profileInfo[1]
            }
            
            if !(userImageInfo.contains("default_photo")) {
                for imageInfo in userImageInfo {
                    alamofireSource.append(AlamofireSource(urlString: imageInfo)!)
                }
                slideshow.backgroundColor = UIColor.white
                slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
                slideshow.pageControl.pageIndicatorTintColor = UIColor.black
                slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
                
                slideshow.setImageInputs(alamofireSource)
            }else {
                slideshow.setImageInputs([ImageSource(image: UIImage(named: "default_photo")!)])
            }
        } else {
            self.showAlertView("Error", message: "No internet connection", completion: nil)
        }
    }
    
   
    @IBAction func backToSwipe(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


