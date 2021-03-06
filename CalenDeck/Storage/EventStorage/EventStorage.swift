//
//  EventStorage.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/26.
//

import Foundation
import UIKit
import RxSwift
import Firebase
import RxFirebase
class EventStorage:EventType{
    let bag = DisposeBag()
    let ref = Database.database().reference()
    var dateArray:[String] = []
    var formatter:DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd"
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    private let myID: String
    var eventList:[Event] = []
    var store = BehaviorSubject<[Event]>(value: [])
    required init(myID:String){
        self.myID = myID
    }
    func convertData(snap:DataSnapshot,to date:Date){
        guard let dict = snap.value! as? Dictionary<String,Any> else {
            self.eventList = [Event(empty: .empty)]
            return
        }
        eventList = []
        dateArray = []
        for i in dict.values{
            let data = i as! Dictionary<String,Any>
            let style = data["style"] as! String
            let mainTitle = data["mainTitle"] as! String
            let subTitle = data["subTitle"] as! String
            let content = data["content"] as! String
            let owner = data["owner"] as! String
            let time = data["time"] as! String
            self.dateArray.append(time)
            if formatter.string(from: date) == time{
                switch style{
                case "create":
                    let card = Card(date: self.formatter.date(from: time)!, title: subTitle, content: content, thumbnail: nil)
                    let evt = Event(style: .create(card), mainTitle: mainTitle, subTitle: subTitle, content: content, owner: owner, time: time)
                    self.eventList.append(evt)
                case "follow":
                    let evt = Event(style: .follow(subTitle), mainTitle: mainTitle, subTitle: subTitle, content: content, owner: owner, time: time)
                    self.eventList.append(evt)
                default:
                    fatalError()
                }
            }
        }
        if !dateArray.contains(formatter.string(from: date)){
            self.eventList = [Event(empty: .empty)]
        }
    }
    func getTimeLine(to date:Date = Date()) -> Completable{
        let subject = PublishSubject<Void>()
        ref.child("users").child(myID).child("events").rx
            .observeSingleEvent(.value)
            .subscribe(onSuccess:{snap in
                self.convertData(snap: snap,to:date)
                self.store.onNext(self.eventList)
//                print("on next -> \(self.eventList.count)")
                subject.onCompleted()
            },onError: { error in
                subject.onError(error)
            })
            .disposed(by: bag)
        return subject.ignoreElements()
    }
    @discardableResult
    func createEvent(style:EventStyle) -> Completable{
        let subject = PublishSubject<Void>()
        let date = formatter.string(from: Date())
        switch style{
        case .create(let card):
            let mainTitle = "\(myID) 님이 새로운 카드를 만들었습니다."
            let newEvent = Event(style: style, mainTitle: mainTitle, subTitle: card.title, content: card.content,owner: myID,time: date)
            ref.child("users").child(myID).child("events").child(card.title).rx
                .setValue(["style":"create","mainTitle":mainTitle,"subTitle":card.title,"content":card.content,"owner":myID,"time":date])
                .subscribe(onSuccess:{_ in
                    self.eventList.append(newEvent)
                    self.store.onNext(self.eventList)
                    subject.onCompleted()
                },onError:{error in
                    subject.onError(error)
                })
                .disposed(by: bag)
            return subject.ignoreElements()
        case .follow(let name):
            let mainTitle = "\(myID) 님과 \(name) 님이 친구가 되었습니다."
            let newEvent = Event(style: style, mainTitle: mainTitle, subTitle: name, content: "",owner: myID,time: "")
            ref.child("users").child(myID).child("events").child(name).rx
                .setValue(["style":"follow","mainTitle":mainTitle,"subTitle":name,"content":"","owner":myID,"time":date])
                .subscribe(onSuccess:{_ in
                    self.eventList.append(newEvent)
                    self.store.onNext(self.eventList)
                    subject.onCompleted()
                },onError:{error in
                    subject.onError(error)
                })
                .disposed(by: bag)
            return subject.ignoreElements()
        case .empty:
            return PublishSubject<Void>().ignoreElements()
        }
    }
}
