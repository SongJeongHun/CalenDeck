//
//  ViewModelType.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import Foundation
class ViewModeltype{
    let sceneCoordinator:SceneCoordinatorType
    let storage:StorageType
    init(sceneCoordinator:SceneCoordinatorType,storage:StorageType){
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
