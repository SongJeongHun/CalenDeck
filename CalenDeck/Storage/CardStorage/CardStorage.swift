//
//  CardStorage.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/12.
//

import RxSwift
import Action
import Firebase
import RxFirebaseDatabase
import NSObject_Rx
import Foundation
class CardStorage{
    let bag = DisposeBag()
    let ref = Database.database().reference()
    private let myID:String
    var cardList:[Card] = []
    var store = BehaviorSubject<[Card]>(value: [])
    required init(myID:String){
        self.myID = myID
    }
    func getCardList() -> Completable{
        let subject = PublishSubject<Void>()
        return subject.ignoreElements()
    }
    func addCardList() -> Completable{
        let subject = PublishSubject<Void>()
        return subject.ignoreElements()
    }
}
