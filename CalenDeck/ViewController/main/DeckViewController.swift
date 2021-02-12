//
//  DeckViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import UIKit
import RxSwift
import Action
import NSObject_Rx
import SideMenu
class DeckViewController: UIViewController,ViewControllerBindableType,SideMenuNavigationControllerDelegate{
    var viewModel:DeckViewModel!
    @IBOutlet weak var currentCard:UIView!
    @IBOutlet weak var deckListButton:UIBarButtonItem!
    override func viewDidLoad() {
        currentCard.layer.cornerRadius = 5.0
        super.viewDidLoad()
    }
    func bindViewModel() {
        deckListButton.rx.action = viewModel.showDeckListAction()
        ApplicationNotiCenter.sideMenuWillDisappear.addObserver()
            .subscribe(onNext:{object in
                guard let object = object as? String else { return }
                print(object)
            })
            .disposed(by: rx.disposeBag)
        ApplicationNotiCenter.sideMenuWillAppear.addObserver()
            .subscribe(onNext:{object in
                guard let object = object as? String else { return }
                print(object)
            })
            .disposed(by: rx.disposeBag)
    }
}
