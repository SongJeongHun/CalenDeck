//
//  Coordinator.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/25.
//

import Foundation
import UIKit
import RxSwift
extension UIViewController{
    var sceneViewController:UIViewController{
        return self.children.first ?? self
    }
}
class Coordinator:SceneCoordinatorType{
    private let bag = DisposeBag()
    private var window:UIWindow
    private var currentVC:UIViewController
    required init(window:UIWindow){
        self.window = window
        currentVC = window.rootViewController!
    }
    func trainsition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        let target = scene.instantiate()
        switch style{
        case .root:
            currentVC = target
            window.rootViewController = target
            subject.onCompleted()
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC =  target.sceneViewController
        case .push:
            guard let nav = target.navigationController else {
                subject.onError(TransitionError.navigationMissing)
                break
            }
            nav.rx.willShow
                .subscribe(onNext:{[unowned self] event in
                    self.currentVC = event.viewController.sceneViewController
                })
                .disposed(by: bag)
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
        }
        return subject.ignoreElements()
    }
    
    func close(animated: Bool) -> Completable {
        return Completable.create{[unowned self]completable in
            if let presentingVC = self.currentVC.presentingViewController{
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            }else if let nav = self.currentVC.navigationController{
                guard nav.popViewController(animated: animated) != nil else{
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            }else{
                completable(.error(TransitionError.unKnown))
            }
            return Disposables.create()
        }
    }
    
   
    
}