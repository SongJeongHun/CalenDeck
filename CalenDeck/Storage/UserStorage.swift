//
//  UserStorage.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/29.
//
import Foundation
import RxSwift
import Action
import Firebase
import RxFirebase
class UserStorage:UserStorageType{
    let bag = DisposeBag()
    let ref = Database.database().reference()
    @discardableResult
    func userJoin(client:User) -> Completable {
        let subject = PublishSubject<Void>()
        ref.child("users").child(client.userID).rx
            .setValue(["userID":client.userID,"userPassWord":client.userPassword,"userEmail":client.userPassword])
            .subscribe { _ in
                subject.onCompleted()
            } onError: { error in
                subject.onError(error)
            }
            .disposed(by:bag)
        return subject.ignoreElements()
    }
    @discardableResult
    func userIDValidationCheck() -> Observable<Bool> {
        let subject = BehaviorSubject<Bool>(value:false)
        ref.child("users").rx
            .observeEvent(.value)
            .subscribe(onNext: {data in
                
                
                
            })
            .disposed(by: bag)
        return subject
    }
}
