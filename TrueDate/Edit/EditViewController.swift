//
//  EditViewController.swift
//  TrueDate
//
//  Created by Armenuhi on 9/23/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage


class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var tutorialViewController = TutorialViewController()
    
    let identifier = "CellIdentifier"
    var currentUser = UserRequestsService().currentUser
    var imageDataFromServer = [[String:Any]]()
    var imageUrl = [String]()
    var imageId = [Int]()
    var checkEditing: Bool?
    var networkStatus: Bool!
    
    
     // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        for cell in collectionView.visibleCells as! [ImageCell] {
            cell.closeImage.isHidden = true
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        for cell in collectionView.visibleCells as! [ImageCell] {
            cell.closeImage.isHidden = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        
        // Check Internet connection
        let result = updateUserInterface()
        if result == true {
            
            loadUserImages()
        } else {
            self.showAlertView("Error", message: "No internet connection", completion: nil)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        checkEditing = false
    }
    
    //MARK: showEditing
    @IBAction func showEditing(_ sender: UIBarButtonItem) {
        if(self.isEditing == true)
        {
            self.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        else
        {
            self.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
    }
    
   
    // MARK: Display user images on list
    func loadUserImages() {
        // Update array every time
       self.imageUrl.removeAll()
        // Get current user Id
        let currentUserId = (currentUser?.id)!
        let updatedId: String = String(currentUserId)
        let getPhotoEndPoint = Constants.GET_PHOTO_ENDPOINT + updatedId
        
        JMLoading.sharedInstance.showActivityIndicator()
        Alamofire.request(getPhotoEndPoint).validate().responseJSON { response in
            JMLoading.sharedInstance.hideActivityIndicator()
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    self.imageDataFromServer = JSON as! [[String:Any]]
                    for image in self.imageDataFromServer{
                        print(image["PhotoURL"] as! String)
                        self.imageUrl.append(image["PhotoURL"] as! String)
                        self.imageId.append(image["PhotoId"] as! Int)
                    }
                }
               self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
   
    // MARK:- prepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // retrieve selected cell & fruit
        if let indexPath = getIndexPathForSelectedCell() {
            let image = self.imageUrl[indexPath.row]
            
            let editDetailViewController = segue.destination as! EditDetialViewController
            editDetailViewController.image = image
        }
    }
    
    // MARK:- Should Perform Segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !isEditing
    }
    
    // MARK:- Get Path For selected Cell
    func getIndexPathForSelectedCell() -> IndexPath? {
        var indexPath:IndexPath?
        if collectionView.indexPathsForSelectedItems!.count > 0 {
            indexPath = collectionView.indexPathsForSelectedItems![0]
        }
        return indexPath
    }
    
    
    // MARK:- Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing == false {
            checkEditing = false

            for cell in collectionView.visibleCells as! [ImageCell] {
                cell.closeImage.isHidden = true
            }
            collectionView.reloadData()}
        else {
            checkEditing = true
            for cell in collectionView.visibleCells as! [ImageCell] {
                cell.closeImage.isHidden = false
            }
        }
        collectionView?.allowsMultipleSelection = editing
    }

  
    //MARK: UIImagePickerController  methods
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.modalPresentationStyle = .fullScreen
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.showsCameraControls = true
            cameraPicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.front) ? .front : .rear

            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            self.showAlertView("Device has no camera", message: nil, completion: nil)
        }
    }
    
    
        //MARK: UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var newImage: UIImage
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImage.scaledToSize(newSize: CGSize.init(width: 512, height: 512))
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = possibleImage.scaledToSize(newSize: CGSize.init(width: 512, height: 512))
        } else {
            newImage = UIImage.init()
        }
        picker.dismiss(animated: true, completion: nil)
        // Get user Id
        let currentUserId = (currentUser?.id)!
        print("currentUserId", currentUserId)
        let id: Int? = Int(currentUserId)
        
        var parameters = [String:Any]()
        parameters["userId"] = id
        
        parameters["Base64String"] = newImage.base64(format:.JPEG(0.5))!
        
        let headers: HTTPHeaders = ["Authorization": "sxfsdfsdfsfsfsf", "Accept": "application/json", "Content-Type" :"application/json"]
        
        Alamofire.request(Constants.POST_PHOTO_ENDPOINT, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            // original URL request
            print("Request is :",response.request!)
            
            self.loadUserImages()
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        // Move Controller
        self.tutorialViewController.moveController()
    }
    
    // MARK:- Add Cell
    @IBAction func addNewItem(_ sender: UIButton) {
        self.showActionSheetInController(sender, title: nil, message: nil, otherButtonTitles: ["Take a photo"], cancelButtonTitle: "Cancel", destructiveButtonTitle: nil) { (action:String) in
            if action == "Take a photo" {
                self.takePhoto()
            }
        }
    }
    
    
    func deletePhoho(sender:UIButton) {
        self.showActionSheetInController(sender, title: nil, message: nil, otherButtonTitles: ["Delete photo"], cancelButtonTitle: "Cancel", destructiveButtonTitle: nil) { (action:String) in
            if action == "Delete photo" {
                let i : Int = (sender.layer.value(forKey: "index")) as! Int
                self.imageUrl.remove(at: i)
            
                let imageId = self.imageId[i]
                let updatedImageId: String = String(imageId)
                
                // Update Delete Endpoint
                let updatedEndpoint = Constants.DELETE_PHOTO_ENDPOINT + updatedImageId
                
                let firstTodoEndpoint: String = updatedEndpoint
                JMLoading.sharedInstance.showActivityIndicator()
                Alamofire.request(firstTodoEndpoint, method: .delete)
                    .responseJSON { response in
                        JMLoading.sharedInstance.hideActivityIndicator()
                        if response.result.error != nil {
                            
                        } else {
                        }
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



// MARK:- UICollectionView DataSource
extension EditViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! ImageCell
        
        cell.closeImage?.layer.setValue(indexPath.row, forKey: "index")
        cell.closeImage?.addTarget(self, action: #selector(self.deletePhoho(sender:)), for: UIControlEvents.touchUpInside)
        
        let imgUrl = self.imageUrl[indexPath.row]
        
        if imgUrl != "" {
            // The image to download
            let remoteImageURL = URL(string: imgUrl)
            // Use Alamofire to download the image
            Alamofire.request(remoteImageURL!, method: .get).responseImage { response in
                guard response.result.value != nil else {
                    // Handle error
                    return
                }
                // Show the downloaded image:
                if let data = response.data {
                    cell.imageView.image = UIImage(data: data)
                }
            }
        }
        if checkEditing == true {
            for cell in collectionView.visibleCells as! [ImageCell] {
                cell.closeImage.isHidden = false
            }
        }else {
            for cell in collectionView.visibleCells as! [ImageCell] {
                cell.closeImage.isHidden = true
            }
        }
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods
extension EditViewController : UICollectionViewDelegate {
    
}

