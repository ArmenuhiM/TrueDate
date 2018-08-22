
//
//  MessageViewModel.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/21.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Bond
import Alamofire
import SwiftyJSON

protocol MessageViewModelType: class {
    
    //Input
    var collectionItemDidSelect: PublishSubject<IndexPath> { get }
    
    // Output
    var newMatchedUsers: Variable<[User]> { get }
    var messageUsers: Variable<[OtherUser]> { get }

}

class MessageViewModel: MessageViewModelType {
    
    var currentUser = UserRequestsService().currentUser
    
    private let disposeBag = DisposeBag()
    
    //Input
    let collectionItemDidSelect = PublishSubject<IndexPath>()
    
    // Output
    let newMatchedUsers = Variable<[User]>([])
    let messageUsers = Variable<[OtherUser]>([])
    
    init() {
       getConversationUsers()
      //  getNewMatchedusers()
        
//        self.collectionItemDidSelect
//            .asObserver()
//            .subscribe(
//                onNext: { indexPath in
//                    print("Index PAth", indexPath.row)
//                    UserDefaults.standard.set(indexPath.row, forKey: "indexRow")
//                  //  self.deleteMatches()
//                })
//            .addDisposableTo(disposeBag)
    }

    
    private func getConversationUsers() {
        Api.ShotRequest.getConversations()
            .flatMap({ conversations -> RxSwift.Observable<Conversation> in
                return RxSwift.Observable.from(conversations)
            })
            .map({ converstion in
                return converstion.otherUser!
            })
            .toArray()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] users in
                    self?.messageUsers.value.append(contentsOf: users)
                }
            )
            .addDisposableTo(disposeBag)
    }
    
    
    
//    private func getNewMatchedusers(){
//        Api.ShotRequest.getMatches()
//            .flatMap({ shots -> RxSwift.Observable<Match> in
//                return RxSwift.Observable<Match>.from(shots)
//            })
//            .map({ shot in
//                return shot.user!
//            })
//            .filter({ (user) -> Bool in
//                return (user.firstName?.characters.count)! < 6
//            })
//            .toArray()
//            .observeOn(MainScheduler.instance)
//            .subscribe(
//                onNext: {[weak self] users in
//                    self?.newMatchedUsers.value.append(contentsOf: users)
//                }
//            )
//            .addDisposableTo(disposeBag)
//    }
//
//    func deleteMatches() {
//        // Current user Id
//        let currentUser = UserRequestsService().currentUser
//        let currentUserId = (currentUser?.id)!
//        let userId: String = String(currentUserId)
//        let baseURL = Constants.DELETE_MATCHED_USERS
//
//        let matchId = self.newMatchedUsers.value[0].matchId
//        let matchIdString = "\(matchId!)"
//        let path = baseURL + userId + "?" + "MatchId" + "=" + matchIdString
//
//        // Delete
//        self.deleteRequest(urlSuffix: path, success: { (responce) in
//            print("Succses")
//            let rowPath = UserDefaults.standard.integer(forKey: "indexRow")
//            self.newMatchedUsers.value.remove(at: rowPath)
//        }) { (error) in
//            print("Error") }
//
//    }
//
//
//    // MARK: - Delete Match
//    func deleteRequest(urlSuffix : String, success: @escaping (_ response: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void)
//    {
//        Alamofire.request(urlSuffix, method: .delete)
//            .responseJSON { response in
//                switch response.result
//                {
//                case .success:
//                    print("Succes")
//                    success(response as AnyObject)
//                case .failure(let error):
//                    print("failure")
//                    failure(error as NSError)
//                }
//        }
//    }
}
