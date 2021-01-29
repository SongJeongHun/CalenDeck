//
//  UserStorageType.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/29.
//

import Foundation
import RxSwift
protocol UserStorageType {
    @discardableResult
    func userJoin(client:User) -> Completable
    @discardableResult
    func userIDValidationCheck(userID:String) -> Observable<Bool>
}
