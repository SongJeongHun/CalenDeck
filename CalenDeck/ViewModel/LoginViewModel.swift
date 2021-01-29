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
    func userJoinAction() -> CocoaAction {
        return CocoaAction{_ in
            let joinViewModel = JoinViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, userID: "")
            let joinScene = Scene.join(joinViewModel)
            return self.sceneCoordinator.trainsition(to: joinScene, using: .modal, animated: true).asObservable().map{_ in}
        }
    }
}
