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
    var selectedDate = BehaviorSubject<Date>(value: Date())
    func datePickAction() -> CocoaAction{
        return CocoaAction{_ in
            let datePickScene = Scene.datePick(self)
            return self.sceneCoordinator.trainsition(to: datePickScene, using: .push, animated: true).asObservable().map{ _ in }
        }
    }
    
}

