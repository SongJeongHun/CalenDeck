//
//  EventType.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/26.
//

import Foundation
import RxSwift
import Firebase
protocol EventType{
    @discardableResult
    func createEvent(style:EventStyle) -> Completable
    @discardableResult
    func getTimeLine(to date:Date) -> Completable
    
    func convertData(snap:DataSnapshot,to date:Date)
   
}
