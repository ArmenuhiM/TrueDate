//
//  SettingsViewController.swift
//  TrueDate
//
//  Created by Armenuhi on 12/5/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import Alamofire

class SettingsTableViewController: UITableViewController, GenderTableViewControllerDelegate {

    var currentUser = UserRequestsService().currentUser
    var tutorialViewController = TutorialViewController()
    var currentValue: Int!
    var userGenderValue: Int!
    var userSelectedGenderValue: Int!
    var imageDataFromServer = [String:Any]()
    var networkStatus: Bool!
    

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Settings"
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        
        // Check Internet connection
        let result = updateUserInterface()
        if result == true {
            
        }else {
            self.showAlertView("Error", message: "No internet connection", completion: nil)
        }
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

    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set("done", forKey: "checkRequestDone")
        doneTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let checkRequestDone = UserDefaults.standard.string(forKey: "checkRequestDone")
        if checkRequestDone != nil  {
        // Get user preferences
         getUserPreferences()
        }else {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGenderView" {
            let vc = segue.destination as! GenderTableViewController
            vc.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Get Request for user Preferences
    func getUserPreferences() {
        
        // Get current user Id
        let currentUserId = (currentUser?.id)!
        let updatedId: String = String(currentUserId)
        let getPreferencesEndPoint = Constants.GET_USER_PREFERENCES + updatedId
        
        Alamofire.request(getPreferencesEndPoint).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.imageDataFromServer = JSON as! [String:Any]
                    print("self.imageDataFromServer", self.imageDataFromServer)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //MARK: - Done Action
    func doneTapped() {
        
        let preferencesUrl = Constants.POST_USER_PREFERENCES
        
        // Get user Id
        let currentUserId = (currentUser?.id)!
        let id: Int? = Int(currentUserId)
        
        // Get user Gender
        let currentUserGender = (currentUser?.gender)!
        
        if currentUserGender == "male" {
            userGenderValue = 1
        }else if currentUserGender == "female"{
            userGenderValue = 2
        }
        
       let selectedGender = UserDefaults.standard.integer(forKey: "selectedGender")
        
        if userGenderValue == 1 && selectedGender == 2 {
            userSelectedGenderValue = 1
        }
        
        if userGenderValue == 2 && selectedGender == 1 {
            userSelectedGenderValue = 2
        }
        
        if userGenderValue == 2 && selectedGender == 2 {
            userSelectedGenderValue = 3
        }
        
        if userGenderValue == 1 && selectedGender == 1 {
            userSelectedGenderValue = 4
        }
        
        if userGenderValue == 1 && selectedGender == 3 {
            userSelectedGenderValue = 5
        }
        
        if userGenderValue == 2 && selectedGender == 3 {
            userSelectedGenderValue = 5
        }
        var parameters = [String:Any]()
        parameters["UserId"] = id
        parameters["GenderPreference"] = userSelectedGenderValue
        
        // Ditance Parameter
        let storedDistance = UserDefaults.standard.integer(forKey: "DistanceCurrentValue")
        print("Current Value ========", storedDistance)
        parameters["Distance"] = storedDistance
        
        let headers: HTTPHeaders = ["Authorization": "test", "Accept": "application/json", "Content-Type" :"application/json"]
        Alamofire.request(preferencesUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
        
        let checkRequestDone = UserDefaults.standard.string(forKey: "checkRequestDone")
        if let updatedcheckRequest: String = checkRequestDone {
            switch updatedcheckRequest {
            case "done":
                // Move Controller
                self.tutorialViewController.moveController()
            case "slider":
                break
            case "cell":
                break
            default:
                break
            }
        }
    }

    
    // MARK: - Detect Slider value updates
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("Began")
            case .moved:
                currentValue = Int(slider.value)
                UserDefaults.standard.set(currentValue, forKey: "DistanceCurrentValue")
                
                let currentValueString = String(currentValue)
                let row = slider.tag
                
                let indexData = IndexPath(row: row, section: 0)
                let cell = tableView.cellForRow(at: indexData) as! DistanceSettingsTableViewCell
                
                let kmData = "mi"
                let sliderTextData = "\(currentValueString) \(kmData)"
                if currentValueString == "101" {
                    cell.distanceData.text = "100+ mi"
                }else {
                    cell.distanceData.text = sliderTextData
                }
            case .ended:
                UserDefaults.standard.set("slider", forKey: "checkRequestDone")
                doneTapped()
            default:
                break
            }
        }
    }
    

    // MARK: - TableViewDatasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "distanceCell", for: indexPath) as! DistanceSettingsTableViewCell
            
            if self.imageDataFromServer.isEmpty {
                cell.distanceSlider.value = 20
                cell.distanceData.text = "20 mi"
                UserDefaults.standard.set(20, forKey: "DistanceCurrentValue")

            }else {
                let userSelectedDistance = self.imageDataFromServer["Distance"] as! Float
                cell.distanceSlider.value = userSelectedDistance
                cell.distanceSlider.minimumTrackTintColor = UIColor.paPinkColor
                
                let userSelectedDistanceInt = Int(userSelectedDistance)
                let currentValueString = String(userSelectedDistanceInt)
                UserDefaults.standard.set(userSelectedDistanceInt, forKey: "DistanceCurrentValue")
                
                let kmData = "mi"
                let sliderTextData = "\(currentValueString) \(kmData)"
                print("sliderTextData", sliderTextData)
                if currentValueString == "101" {
                    cell.distanceData.text = "100+ mi"
                }else {
                    cell.distanceData.text = sliderTextData
                }
            }
            cell.distanceSlider.tag = indexPath.row
            cell.distanceSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath) as! GenderSettingsTableViewCell
            
            if self.imageDataFromServer.isEmpty {
                let selectedGenderTitle = UserDefaults.standard.string(forKey: "selectedGenderTitle")
                if selectedGenderTitle == nil {
                    // Get user Gender
                    let currentUserGender = (currentUser?.gender)!
                    switch currentUserGender {
                    case "male":
                        cell.genderData.text = "Women"
                        UserDefaults.standard.set(2, forKey: "selectedGender")
                        UserDefaults.standard.set("Women", forKey: "selectedGenderTitle")

                    case "female":
                        cell.genderData.text = "Men"
                        UserDefaults.standard.set(1, forKey: "selectedGender")
                        UserDefaults.standard.set("Men", forKey: "selectedGenderTitle")

                    default:
                        break
                    }
                }
                
            }else {
               let selectedGenderTitle = UserDefaults.standard.string(forKey: "selectedGenderTitle")
               cell.genderData.text = selectedGenderTitle
            }
            return cell
        }
    }
    
  
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        }else {
            UserDefaults.standard.set("cell", forKey: "checkRequestDone")
            performSegue(withIdentifier: "showGenderView", sender: self)
        }
    }
}
