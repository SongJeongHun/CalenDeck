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
    var currentVC:UIViewController
    required init(window:UIWindow){
        self.window = window
        currentVC = window.rootViewController!
    }
    func trainsition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let target = scene.instantiate()
        let subject = PublishSubject<Void>()
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
            if type(of: target) == DatePickViewController.self{
                guard let nav = currentVC.children.first as? UINavigationController else {
                    print("error occur. current VC is -> \(currentVC)")
                    subject.onError(TransitionError.navigationMissing)
                    break
                }
                nav.rx.willShow
                    .subscribe(onNext:{[unowned self] event in
                        self.currentVC = event.viewController.sceneViewController.parent!.parent!
                    })
                    .disposed(by: bag)
                nav.pushViewController(target, animated: animated)
                currentVC = target.sceneViewController
                subject.onCompleted()
            }else if type(of: target) == DeckListViewController.self{
                currentVC.dismiss(animated: true, completion: nil)
                currentVC = window.rootViewController!
                guard let nav = currentVC.children.last as? UINavigationController else {
                    print("error occur. current VC is -> \(currentVC)")
                    subject.onError(TransitionError.navigationMissing)
                    break
                }
                let vc = target as! DeckListViewController
                vc.navigationItem.title = "덱 편집"
                vc.editButton.isHidden = true
                vc.cardAddButton.rx.action = vc.viewModel.cardManageButtonAction()
                nav.rx.willShow
                    .subscribe(onNext:{[unowned self] event in
                        self.currentVC = event.viewController.sceneViewController.parent!.parent!
                    })
                    .disposed(by: bag)
                nav.pushViewController(target, animated: animated)
                currentVC = target.sceneViewController
                subject.onCompleted()
            }else{
                guard let nav = currentVC.children.last as? UINavigationController else {
                    print("error occur. current VC is -> \(currentVC)")
                    subject.onError(TransitionError.navigationMissing)
                    break
                }
                nav.rx.willShow
                    .subscribe(onNext:{[unowned self] event in
                        self.currentVC = event.viewController.sceneViewController.parent!.parent!
                    })
                    .disposed(by: bag)
                nav.pushViewController(target, animated: animated)
                currentVC = target.sceneViewController
                subject.onCompleted()
            }
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
