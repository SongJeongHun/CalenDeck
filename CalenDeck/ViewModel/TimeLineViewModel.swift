//
//  TimeLineViewModel.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import Foundation
import RxSwift
import RxCocoa
import Action
class TimeLineViewModel:ViewModeltype{
    lazy var eventStorage = EventStorage(myID: userID)
    var timeLineList = [Event(style: .follow("test"), mainTitle: "test", subTitle: "test", content: "test", owner: "test", time: "test"),Event(style: .follow("test"), mainTitle: "test", subTitle: "test", content: "test", owner: "test", time: "test"),Event(style: .follow("test"), mainTitle: "test", subTitle: "test", content: "test", owner: "test", time: "test")]
    func testAction() -> CocoaAction{
        return CocoaAction{_ in
            self.eventStorage.createEvent(style: .follow("tset!"))
            print(self.eventStorage.eventList)
            return Observable.empty()
        }
    }
}
