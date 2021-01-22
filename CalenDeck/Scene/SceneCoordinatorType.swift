//
//  SceneCoordinatorType.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import Foundation
import RxSwift
protocol SceneCoordinatorType {
    @discardableResult
    func trainsition(to scene:Scene,using style:TransitionStyle,animated:Bool) -> Completable
    @discardableResult
    func close(animated:Bool) -> Completable
}
