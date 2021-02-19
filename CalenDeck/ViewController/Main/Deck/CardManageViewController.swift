//
//  CardManageViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/17.
//

import UIKit
import RxSwift
import NSObject_Rx
import Action

class CardManageViewController: UIViewController,ViewControllerBindableType{
    var viewModel:DeckViewModel!
    @IBOutlet weak var currentCard:UIView!
    @IBOutlet weak var contentPanel:UIView!
    @IBOutlet weak var thumbnailPanel:UIView!
    @IBOutlet weak var thumbnailImage:UIImageView!
    @IBOutlet weak var content:UITextView!
    @IBOutlet weak var currentDay:UILabel!
    @IBOutlet weak var currentMonth:UIImageView!
    @IBOutlet weak var thumbnailButton:UIButton!
    @IBOutlet weak var titleButton:UIButton!
    @IBOutlet weak var contentButton:UIButton!
    @IBOutlet weak var bottomConstraint:NSLayoutConstraint!
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = presentingViewController!
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        setUI()
        super.viewDidLoad()
    }
    func bindViewModel() {
        thumbnailButton.rx.tap
            .throttle(.milliseconds(5000), scheduler:MainScheduler.instance)
            .subscribe(onNext:{_ in
                
            })
            .disposed(by: rx.disposeBag)
        titleButton.rx.tap
            .throttle(.milliseconds(5000), scheduler:MainScheduler.instance)
            .subscribe(onNext:{_ in
                
            })
            .disposed(by: rx.disposeBag)
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map{$0.userInfo}
            .subscribe(onNext:{ [unowned self] info in
                if let frame = info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                    let keyboardHeight = frame.cgRectValue.height
                    self.bottomConstraint.constant = keyboardHeight
                }
            })
            .disposed(by: rx.disposeBag)
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map{$0.userInfo}
            .subscribe(onNext:{ [unowned self] info in
                if let frame = info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                    let keyboardHeight = frame.cgRectValue.height
                    self.bottomConstraint.constant -= keyboardHeight
                }
            })
            .disposed(by: rx.disposeBag)
        
       
        
    }
    func setUI(){
        currentCard.layer.shadowRadius = 5.0
        currentCard.layer.shadowOffset = CGSize(width: 5, height: 5)
        currentCard.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        currentCard.layer.shadowOpacity = 0.6
        currentCard.layer.borderWidth = 0.5
        currentCard.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentPanel.layer.cornerRadius = 5.0
        thumbnailPanel.layer.cornerRadius = 5.0
        currentCard.layer.cornerRadius = 5.0
    }
}
