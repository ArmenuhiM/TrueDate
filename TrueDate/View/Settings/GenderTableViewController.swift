//
//  GenderTableViewController.swift
//  TrueDate
//
//  Created by Armenuhi on 12/5/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

//MARK: step 1 Add Protocol here
protocol GenderTableViewControllerDelegate: class {
    func doneTapped()
}

class GenderTableViewController: UITableViewController {

   var titleData = [String]()
    
    //MARK: step 2 Create a delegate property here, don't forget to make it weak!
    weak var delegate: GenderTableViewControllerDelegate?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleData = ["Men", "Women", "Men and Women"]
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //MARK: step 3 Add the delegate method call here
        delegate?.doneTapped()
    }
    
      
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    // MARK: - TableViewDatasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath) as! GenderTableViewCell
        
        let selectedGenderTitle = UserDefaults.standard.string(forKey: "selectedGenderTitle")
       
        if selectedGenderTitle != nil {
            switch selectedGenderTitle {
            case "Men"?:
                if indexPath.row == 0 {
                    cell.checkImage.isHidden = false
                }
                
            case "Women"?:
                if indexPath.row == 1 {
                    cell.checkImage.isHidden = false
                }
                
            case "Men and Women"?:
                if indexPath.row == 2 {
                    cell.checkImage.isHidden = false
                }
            default:
                print("Integer out of range")
            }
        }
        
        cell.genderTitleLabel!.text = titleData[indexPath.row]
        
        return cell
    }
    
   
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for cell in tableView.visibleCells as! [GenderTableViewCell] {
            cell.checkImage.isHidden = true
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! GenderTableViewCell
        cell.checkImage.isHidden = false
        UserDefaults.standard.set(indexPath.row + 1, forKey: "selectedGender")
        
        let selectedGender = UserDefaults.standard.integer(forKey: "selectedGender")
        
        if selectedGender == 1 {
            UserDefaults.standard.set("Men", forKey: "selectedGenderTitle")
        }
        if selectedGender == 2 {
            UserDefaults.standard.set("Women", forKey: "selectedGenderTitle")
        }
        if selectedGender == 3 {
            UserDefaults.standard.set("Men and Women", forKey: "selectedGenderTitle")
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt  indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GenderTableViewCell
             cell.checkImage.isHidden = true
    }
}
