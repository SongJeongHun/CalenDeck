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
    var formatter:DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd"
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
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
    func addCard(card:Card) -> Completable{
        let subject = PublishSubject<Void>()
        ref.child("users").child(myID).child("cards").child(card.title).rx
            .setValue(["title":card.title,"content":card.content,"date":formatter.string(from: card.date) ,"thumbnail":card.thumbnail ?? "none","grade":card.grade])
            .subscribe(onSuccess:{ _ in
                self.cardList.append(card)
                self.store.onNext(self.cardList)
                subject.onCompleted()
            })
            .disposed(by: bag)
        return subject.ignoreElements()
    }
}
