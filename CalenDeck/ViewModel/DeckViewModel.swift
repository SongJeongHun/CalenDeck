//
//  DeckViewModel.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import Foundation
import RxSwift
import RxCocoa
import Action
class DeckViewModel:ViewModeltype{
    lazy var cardStorage = CardStorage(myID: userID)
    lazy var eventHandler = EventStorage(myID: userID)
    var currentMonth = BehaviorSubject<Int>(value: 0)
    var currentYear = BehaviorSubject<Int>(value: 0)
    func showDeckListAction() -> CocoaAction{
        return CocoaAction{_ in
            let deckListScene = Scene.deckList(self)
            return self.sceneCoordinator.trainsition(to: deckListScene, using: .modal, animated: true).asObservable().map{ _ in }
        }
    }
    func monthPickAction() -> CocoaAction{
        return CocoaAction{_ in
            let monthPickScene = Scene.monthPick(self)
            return self.sceneCoordinator.trainsition(to: monthPickScene, using: .push, animated: true).asObservable().map{ _ in }
        }
    }
    func deckEditButtonAction() -> CocoaAction{
        return CocoaAction{ _ in
            let deckEditScene = Scene.deckEdit(self)
            return self.sceneCoordinator.trainsition(to: deckEditScene, using: .push, animated: true).asObservable().map{ _ in }
        }
    }
}
