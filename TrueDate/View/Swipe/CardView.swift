//
//  CardView.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/10.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire

class CardView: UIView {
    
    var user: User! {
        didSet {
            update()
        }
    }

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func update(){
        name.text = "\((user.firstName)!)"
        
        let userId = String(user.id)
        
        // Get current user Id
        let getUserEndPoint = Constants.GET_USER_ENDPOINT + userId
        
        Alamofire.request(getUserEndPoint).validate().responseJSON { response in
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let swiftyData = JSON(response.result.value!)
                    let userPhotos = swiftyData["Photos"].arrayValue
                    if userPhotos.count > 0 {
                        for item in userPhotos {
                            let userPhoto = item["PhotoURL"].stringValue
                            self.image.sd_setImage(with: URL(string: userPhoto))
                            self.name.textColor = .white
                            break
                        }
                    } else {
                        self.image.image = UIImage(named: "default_photo")
                        self.name.textColor = .black
                    }
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

