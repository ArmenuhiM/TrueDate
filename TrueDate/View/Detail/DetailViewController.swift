//
//  DetailViewController.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/22.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import ImageSlideshow

//MARK: step 1 Add Protocol here
protocol DetailViewControllerDelegate: class {
     func nopeTapped(_ sender: Any)
     func likeTapped(_ sender: Any)
}

class DetailViewController: UIViewController {
    
    var user: User?
    var photo: Photos?
    var networkStatus: Bool!
    
    //MARK: step 2 Create a delegate property here, don't forget to make it weak!
    weak var delegate: DetailViewControllerDelegate?
    
    @IBOutlet var slideshow: ImageSlideshow!
    var detailImageInfo = [String]()
    
    var alamofireSource = [AlamofireSource]()
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var introduction: UILabel!
    @IBOutlet weak var nopeButton: MovableUIButton!
    @IBOutlet weak var likeButton: MovableUIButton!
    
    @IBOutlet weak var distanceLabel: UILabel!
    class func instantiateFromStoryboard() -> DetailViewController {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! DetailViewController
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

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.transitioningDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        
        // Check Internet connection
        let result = updateUserInterface()
        if result == true {
            name.text = "\((user?.firstName)!), \(Int(arc4random_uniform(20)) + 20)"
            if (user?.distance) != nil {
                distanceLabel.text = String(user!.distance) + " miles away"
            }
            if (user?.about) != nil {
                introduction.text = user!.about
            }
            
            if detailImageInfo.count > 0 {
                for imageInfo in detailImageInfo {
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
    
    //            if (user?.photoUrl?.isEmpty)! {
    //                image.image = UIImage(named: "default_photo")
    //            }else {
    //                let photoUrl: String =  (user?.photoUrl)!
    //                if photoUrl != "" {
    //                    image.sd_setImage(with: URL(string: photoUrl))
    //                }
    //            }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nopeButton.appearFromLeft()
        likeButton.appearFromRight()
    }
    
    @IBAction func nopeAction(_ sender: Any) {
        UserDefaults.standard.set("comesFromChat", forKey: "dedicate")
        self.dismiss(animated: true, completion: nil)

        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.delegate?.nopeTapped(self)
        }
    }
    
    @IBAction func likeAction(_ sender: Any) {
        UserDefaults.standard.set("comesFromChat", forKey: "dedicate")
        self.dismiss(animated: true, completion: nil)
        
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.delegate?.likeTapped(self)
        }
    }
    
    @IBAction func backToSwipe(_ sender: Any) {
        UserDefaults.standard.set("comesFromChat", forKey: "dedicate")
        self.dismiss(animated: true, completion: nil)
    }
}

//extension DetailViewController: UIViewControllerTransitioningDelegate {
//    
//    func copyImageView() -> UIImageView {
//        let image = UIImageView(image: self.image.image)
//        image.frame = self.image.convert(self.image.bounds, to: self.view)
//        image.contentMode = self.image.contentMode
//        return image
//    }
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return PresentedAnimater()
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return DismissedAnimater()
//    }
//}

