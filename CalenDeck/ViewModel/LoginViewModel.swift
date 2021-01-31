//
//  LoginViewModel.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/27.
//

import Foundation
import RxSwift
import Action
class LoginViewModel:ViewModeltype{
    let userStorage = UserStorage()
    func userJoinAction() -> CocoaAction {
        return CocoaAction{_ in
            let joinViewModel = JoinViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, userID: "")
            let joinScene = Scene.join(joinViewModel)
            return self.sceneCoordinator.trainsition(to: joinScene, using: .modal, animated: true).asObservable().map{_ in}
        }
    }
    func loginFailAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "알림", message: "로그인 실패", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(ok)
        return alertController        
    }
    func loginSuccessAction(userID:String) -> CocoaAction{
        return CocoaAction{_ in
            let deckViewModel = DeckViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, userID: userID)
            let timeLineViewModel = TimeLineViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, userID: userID)
            let mainScene = Scene.main(timeLineViewModel, deckViewModel)
            return self.sceneCoordinator.trainsition(to: mainScene, using: .root, animated: true).asObservable().map{ _ in }
        }
    }
}
