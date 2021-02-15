//
//  ApplicationNotiCenter.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/12.
//

import Foundation
import RxSwift
enum ApplicationNotiCenter:NotificationCenterType{
    case sideMenuWillAppear
    case sideMenuWillDisappear
    var name:Notification.Name{
        switch self{
        case .sideMenuWillAppear:
            return Notification.Name("sideMenuWillAppear")
        case .sideMenuWillDisappear:
            return Notification.Name("sideMenuWillDisappear")
        }
    }
}
protocol NotificationCenterType{
    var name:Notification.Name{ get }
}
extension NotificationCenterType{
    func addObserver() -> Observable<Any?>{
        return NotificationCenter.default.rx.notification(self.name).map{ $0.object }
    }
    func post(object:Any? = nil){
        NotificationCenter.default.post(name:self.name, object: object,userInfo: nil)
    }
}


