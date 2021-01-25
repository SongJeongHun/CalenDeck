//
//  MemoryStorage.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//
import Foundation
import RxSwift
import RxCocoa
import Action
class MemoryStorage:StorageType{
    private var list = [Card(year: 2021, month: 1, day: 22, title: "CalenDeckProject", content: "testText", thumbnail: nil),Card(year: 2021, month: 1, day: 22, title: "CalenDeckProject", content: "testText", thumbnail: nil)]
    lazy var store = BehaviorSubject<[Card]>(value: list)
    @discardableResult
    func createCard(year: Int, month: Int, day: Int) -> Observable<Card> {
        let card = Card(year: year, month: month, day: day, title: "", content: "", thumbnail: nil)
        list.append(card)
        store.onNext(self.list)
        return Observable.just(card)
    }
    @discardableResult
    func myDeck() -> Observable<[Card]> {
        return store
    }
    @discardableResult
    func update(original:Card,newCard: Card) -> Observable<Card> {
        if let index = list.firstIndex(where:{ $0 == original }){
            self.list.remove(at: index)
            self.list.insert(newCard, at: index)
        }
        store.onNext(list)
        return Observable.just(newCard)
    }
    @discardableResult
    func delete(card: Card) -> Observable<Card> {
        if let index = list.firstIndex(where:{ $0 == card}){
            self.list.remove(at: index)
        }
        store.onNext(list)
        return Observable.just(card)
    }
}
