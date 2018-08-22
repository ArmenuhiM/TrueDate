//
//  EditDetialViewController.swift
//  TrueDate
//
//  Created by Armenuhi on 9/23/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class EditDetialViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if image != nil {
            // The image to download
            let remoteImageURL = URL(string: image!)
            // Use Alamofire to download the image
            Alamofire.request(remoteImageURL!, method: .get).responseImage { response in
                guard response.result.value != nil else {
                    // Handle error
                    return
                }
                // Show the downloaded image:
                if let data = response.data {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
