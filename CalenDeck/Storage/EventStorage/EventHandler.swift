//
//  EventHandler.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/26.
//

import Foundation
import UIKit
import RxSwift
class EventHandler:EventType{
    private let myID: String
    var eventList:[Event] = []
    lazy var store = BehaviorSubject<[Event]>(value: eventList)
    required init(myID:String){
        self.myID = myID
    }
    @discardableResult
    func getTimeLine() -> Observable<[Event]>{
        return store
    }
    @discardableResult
    func createEvent(style:EventStyle) -> Observable<Event>{
        switch style{
        case .create(let card):
            let mainTitle = "\(myID) 님이 새로운 카드를 만들었습니다."
            let newEvent = Event(style: style, mainTitle: mainTitle, subTitle: card.title, content: card.content,owner: myID,time: "")
            eventList.append(newEvent)
            store.onNext(eventList)
            return Observable.just(newEvent)
        case .follow(let name):
            let mainTitle = "\(myID) 님과 \(name) 님이 친구가 되었습니다."
            let newEvent = Event(style: style, mainTitle: mainTitle, subTitle: name, content: "",owner: myID,time: "")
            eventList.append(newEvent)
            store.onNext(eventList)
            return Observable.just(newEvent)
        }
    }
    @discardableResult
    func delete(type: Event) -> Observable<Event> {
        if let index = eventList.firstIndex(where: {$0 == type}){
            eventList.remove(at: index)
        }
        store.onNext(eventList)
        return Observable.just(type)
    }
}
