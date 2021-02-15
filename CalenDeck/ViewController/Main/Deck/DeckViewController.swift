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
    let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    @IBOutlet weak var currentCard:UIView!
    @IBOutlet weak var deckListButton:UIBarButtonItem!
    @IBOutlet weak var testAddButton:UIBarButtonItem!
    @IBOutlet weak var contentPanel:UIView!
    @IBOutlet weak var thumbnailPanel:UIView!
    @IBOutlet weak var thumbnailImage:UIImageView!
    @IBOutlet weak var content:UILabel!
    @IBOutlet weak var currentDay:UILabel!
    @IBOutlet weak var currentMonth:UIImageView!
    var selectedDate = Date()
    override func viewDidLoad() {
        viewModel.cardStorage.getCardList()
        setUI()
        super.viewDidLoad()
    }
    func bindViewModel() {
        deckListButton.rx.action = viewModel.showDeckListAction()
        ApplicationNotiCenter.sideMenuWillDisappear.addObserver()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{_ in
                self.shadowView.isHidden = true
            })
            .disposed(by: rx.disposeBag)
        ApplicationNotiCenter.sideMenuWillAppear.addObserver()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] menuWidth in
                guard let width = menuWidth as? CGFloat else { return }
                self.shadowView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - width, height: UIScreen.main.bounds.height)
                self.shadowView.isHidden = false
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        setShadowView()
        contentPanel.layer.cornerRadius = 5.0
        thumbnailPanel.layer.cornerRadius = 5.0
        currentCard.layer.cornerRadius = 5.0
    }
    func setShadowView(){
        shadowView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        shadowView.layer.zPosition = 1
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.addSubview(shadowView)
        shadowView.isHidden = true
    }
}
