//
//  CardStorageType.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/12.
//

import Foundation
import RxSwift
protocol CardStorageType {
    func getCardList(year:Int,month:Int) -> Completable
    func addCard(card:Card) -> Completable
    
    
}
