//
//  ShotRequest.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/21.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import Alamofire
import RxSwift
import Alamofire
import ObjectMapper
import SwiftyJSON

extension Api {
    
    final class ShotRequest {
        
        //GET: /shots/
        static func getShots() -> Observable<[Shot]> {
            
            let currentUser = UserRequestsService().currentUser
            let currentUserId = (currentUser?.id)!
            let userId: String = String(currentUserId)
            let baseURL = "http://true--date-secure51-ezhostingserver-com-5q1py9nvyyhw.runscope.net/Api/Search/"
            let path = baseURL + userId
            print("Path", path)
            
            return Observable.create{ observer -> Disposable in
                let request = Alamofire.request(path)
                    
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            print("SHOTS response =====", response.result.value!)
                            
                            let shots : [Shot] = Mapper<Shot>().mapArray(JSONObject: value)!
                            print("SHOTS DATA ======", shots)
                            
                            // Check result
                            if shots.isEmpty {
                                
                                // post a notification
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil)
                                // `default` is now a property, not a method call
                                
                            }
                            
                            observer.onNext(shots)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                }
                return Disposables.create(with: { request.cancel() })
            }
        }
        
        
        //GET: /matches/
        static func getMatches() -> Observable<[Match]> {
            
            let currentUser = UserRequestsService().currentUser
            let currentUserId = (currentUser?.id)!
            let userId: String = String(currentUserId)
            let baseURL = "http://true--date-secure51-ezhostingserver-com-5q1py9nvyyhw.runscope.net/api/Matches/"
            let path = baseURL + userId
            print("Path", path)
            
            return Observable.create{ observer -> Disposable in
                let request = Alamofire.request(path)
                    
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            print("Matches response", response.result.value!)
                            
                            let matches : [Match] = Mapper<Match>().mapArray(JSONObject: value)!
                            print("MATCHES DATA ======= ", matches)
                            
                            observer.onNext(matches)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                }
                return Disposables.create(with: { request.cancel() })
            }
        }
        
        
        //GET: /Conversation/
        static func getConversations() -> Observable<[Conversation]> {

            let currentUser = UserRequestsService().currentUser
            let currentUserId = (currentUser?.id)!
            let userId: String = String(currentUserId)
            let baseURL = Constants.GET_USER_CONVERSATIONS
            let path = baseURL + userId
            print("Path", path)

            return Observable.create{ observer -> Disposable in
                let request = Alamofire.request(path)

                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):

                            let conversations : [Conversation] = Mapper<Conversation>().mapArray(JSONObject: value)!
                            print("Conversations DATA ======", conversations)

                            observer.onNext(conversations)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                }
                return Disposables.create(with: { request.cancel() })
            }
        }
}
}

