
//
//  MainViewController.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/07.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreLocation
import Alamofire

class MainViewController: BaseButtonBarPagerTabStripViewController<TabItemCell>, CLLocationManagerDelegate {
 
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    var locationArray: [String]? = [String]()
    
    var locationManager: CLLocationManager? = CLLocationManager()
    var locations: [CLLocation]? = [CLLocation]()
    
    var networkStatus: Bool!
   
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "TabItemCell", bundle: Bundle(for: TabItemCell.self), width: { (cell: IndicatorInfo) -> CGFloat in
            return 55.0
        })
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.alertLabel.isHidden = true
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
            showActionsheet()
        }
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.newAlert(_:)), name: NSNotification.Name(rawValue: "newAlert"), object: nil)
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.newAlertHide(_:)), name: NSNotification.Name(rawValue: "newAlertHide"), object: nil)
    }
    
    // handle notification
    func newAlertHide(_ notification: NSNotification) {
        self.alertLabel.isHidden = true
    }
    
    // handle notification
    func newAlert(_ notification: NSNotification) {
       self.alertLabel.isHidden = false
    }

    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .clear
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = false
        settings.style.buttonBarMinimumLineSpacing = view.frame.width/4
        settings.style.buttonBarLeftContentInset = 200
        settings.style.buttonBarRightContentInset = 200
        settings.style.buttonBarItemLeftRightMargin = 0
        
        changeCurrentIndexProgressive = {(oldCell: TabItemCell?, newCell: TabItemCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
                guard changeCurrentIndex == true else { return }
                oldCell?.imageView.tintColor = UIColor.TindestColor.darkGray
                //oldCell?.newAlert.tintColor = UIColor.TindestColor.mainRed
                newCell?.imageView.tintColor = UIColor.TindestColor.mainRed
            }
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.statusManager), name: .flagsChanged, object: Network.reachability)
        let dedicateInfo = UserDefaults.standard.string(forKey: "dedicate")
        if dedicateInfo == "comesFromChat" {
            moveToViewController(at: 2, animated: false)
            //UserDefaults.standard.set("", forKey: "dedicate")
        } else {
            moveToViewController(at: 1, animated: false)
        }
        
        //Location Manager code to fetch current location
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        // Start location manager
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
      
        super.viewDidLoad()
    }
    
    //    // MARK: - Reachability
    func updateUserInterface() -> Bool {
        guard let status = Network.reachability?.status else { return networkStatus! }
        switch status {
        case .unreachable:
            networkStatus = false
        case .wifi:
            networkStatus = true
        case .wwan:
            networkStatus = true
        }
        
        return networkStatus!
    }
    
    
    func statusManager(_ notification: NSNotification) {
        let result = updateUserInterface()
        if result == true {
            print("True", true)
        }else {
            print("False", false)
        }
    }
    
    
    
    // MARK: Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        let lat = String(format: "%f", (newLocation.coordinate.latitude))
        let lng = String(format: "%f", (newLocation.coordinate.longitude))
        
        locationArray?.append(lat)
        locationArray?.append(lng)
        print("LOCATION ARRAY", locationArray!)
        
         locationManager?.startUpdatingLocation()
         locationManager?.delegate = nil
        
     // Check Internet connection
        let result = updateUserInterface()
        if result == true {
        
        userCurrentLocation()
        } else {
             self.showAlertView("Error", message: "No internet connection", completion: nil)
        }
    }
    
    func showActionsheet() {
        locationImageView.isHidden = false
        
        let actionSheet = UIAlertController(title: "Where are you", message: "In order to suggest potential matches near you, True Date needs to know where you are.",preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Open Settings", style: .default, handler:
            self.openSettingsAction))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func openSettingsAction(alert: UIAlertAction) {
        self.open(scheme: "App-prefs:root=LOCATION_SERVICES")
    }
    
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    // MARK: - Send User Current Location to server
    func userCurrentLocation() {
     
        if (self.locationArray?.isEmpty)! {
        }else {
            let latitude = self.locationArray?[0]
            let longitude = self.locationArray?[1]
            
            // Get current user data
            let currentUser = UserRequestsService().currentUser
            
            // Get current user Id
            let currentUserId = (currentUser?.id)!
            
            // Parameters for post requset
            var parameters = [String:Any]()
            parameters["UserId"] = currentUserId
            parameters["Latitude"] = latitude
            parameters["Longitude"] = longitude
            
            let headers: HTTPHeaders = ["Authorization": "test", "Accept": "application/json", "Content-Type" :"application/json"]
            
            Alamofire.request(Constants.USER_CURRENT_LOCATION_ENDPOINT, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                // original URL request
                print("LAT AND LNG SENDED:",response.request!)
            }
        }
    }

   
    
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
             return [ProfileViewController.instantiateFromStoryboard(), SwipeViewController.instantiateFromStoryboard(), MessageViewController.instantiateFromStoryboard(),]
    }
    
    override func configure(cell: TabItemCell, for indicatorInfo: IndicatorInfo) {
        cell.imageView.image = indicatorInfo.image?.withRenderingMode(.alwaysTemplate)
        cell.newAlert.image = indicatorInfo.newAlert?.withRenderingMode(.alwaysTemplate)
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        print("toIndex", toIndex)
        print("progressPercentage", progressPercentage)

        if (toIndex == 1 && progressPercentage == 1) {
            print("Here")
//            let firstChildnext = viewControllers[1] as! SwipeViewController
//            let secondChild = viewControllers[2] as! MessageViewController
//            firstChildnext.messagesAlertTrue = secondChild.messagesAlertTrue
//            print("firstChildnext.messagesAlertTrue", firstChildnext.messagesAlertTrue)
//            print("secondChild.messagesAlertTrue",secondChild.messagesAlertTrue)

        }
    }
}
