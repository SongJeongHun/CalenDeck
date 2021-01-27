//
//  EventType.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/26.
//

import Foundation
import RxSwift
protocol EventType{
    @discardableResult
    func createEvent(style:EventStyle) -> Observable<Event>
    @discardableResult
    func getTimeLine() -> Observable<[Event]>
    @discardableResult
    func delete(type:Event) -> Observable<Event>
   
}
