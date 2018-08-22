//
//  ApiClientService.swift
//  TrueDate
//
//  Created by Armenuhi on 9/16/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import Alamofire

struct ServiceError : Error {
    var desc : String?
}
class ApiClientService {
    
    //     static let baseUrl:String = "http://www.nurfurkv.bget.ru/handler/"
    static let baseUrl:String = "http://true--date-secure51-ezhostingserver-com-5q1py9nvyyhw.runscope.net/api/Users"
    
    static let sessionManager = Alamofire.SessionManager.default
    
    class func getRequest(_ strURL: String, success:@escaping (AnyObject) -> Void, failure:@escaping (NSError) -> Void) {
        sessionManager.request(self.baseUrl + strURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
    }
    
    class func postRequest(_ strURL: String, params : [String : Any]?, success:@escaping (Any) -> Void, failure:@escaping (String) -> Void) {
        let urlString = strURL;
        
        sessionManager.request(urlString, method: .post, parameters: params, encoding: URLEncoding.methodDependent, headers: nil).validate().responseJSON { (response) in
            //            debugPrint(response)
            
            if response.result.isSuccess {
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                    success(json)
                }
            }
            
            if let error = response.result.error {
                failure(error.localizedDescription)
            }
        }
    }
    
    static func processError(_ responce: Any?) -> Any? {
        
        if let _responce = responce as? [Any] {
            let error = _responce.first as? [String:Any]
            let errorText = error?["fail"] ?? error?["error"]
            return errorText
        }
        
        return nil
    }
}
