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
    func showDeckListAction() -> CocoaAction{
        return CocoaAction{_ in
            let deckListScene = Scene.deckList(self)
            return self.sceneCoordinator.trainsition(to: deckListScene, using: .modal, animated: true).asObservable().map{ _ in }
        }
    }
}
