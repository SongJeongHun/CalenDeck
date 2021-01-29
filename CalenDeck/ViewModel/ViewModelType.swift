//
//  ViewModelType.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import Foundation
class ViewModeltype{
    let userID:String
    let sceneCoordinator:Coordinator
    let storage:StorageType
    init(sceneCoordinator:Coordinator,storage:StorageType,userID:String){
        self.userID = userID
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
