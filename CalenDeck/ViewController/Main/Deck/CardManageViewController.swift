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

class CardManageViewController: UIViewController,ViewControllerBindableType, UINavigationControllerDelegate{
    var viewModel:DeckViewModel!
    let picker = UIImagePickerController()
    @IBOutlet weak var currentCard:UIView!
    @IBOutlet weak var contentPanel:UIView!
    @IBOutlet weak var thumbnailPanel:UIView!
    @IBOutlet weak var thumbnailImage:UIImageView!
    @IBOutlet weak var content:UITextView!
    @IBOutlet weak var currentDay:UILabel!
    @IBOutlet weak var cardTitle:UILabel!
    @IBOutlet weak var currentMonth:UIImageView!
    @IBOutlet weak var thumbnailButton:UIButton!
    @IBOutlet weak var monthPickButton:UIBarButtonItem!
    @IBOutlet weak var titleButton:UIButton!
    @IBOutlet weak var contentButton:UIButton!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    @IBOutlet weak var saveButton:UIBarButtonItem!
    @IBOutlet weak var bottomConstraint:NSLayoutConstraint!
    var currentImage:UIImage? = nil
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = presentingViewController!
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        setUI()
        setGesture()
        indicator.isHidden = true
        picker.delegate = self
        super.viewDidLoad()
    }
    func bindViewModel() {
        notificationBinding()
        saveButton.rx.tap
            .throttle(.milliseconds(5000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{_ in
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                let date = self.viewModel.selectedDate
                let title = self.cardTitle.text
                let content = self.content.text
                let card = Card(date: date, title: title!, content: content!, thumbnail: nil)
                self.viewModel.cardSaveAction(card: card, img: self.currentImage)
                    .subscribe(onCompleted:{
                        self.indicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    })
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
        monthPickButton.rx.action = viewModel.monthPickModalAction()
        thumbnailButton.rx.tap
            .throttle(.milliseconds(5000), scheduler:MainScheduler.instance)
            .subscribe(onNext:{_ in
                self.addThumbnailAlert()
            })
            .disposed(by: rx.disposeBag)
        titleButton.rx.tap
            .observeOn(MainScheduler.instance)
            .throttle(.milliseconds(5000), scheduler:MainScheduler.instance)
            .subscribe(onNext:{_ in
                self.addSetTitleAlert()
            })
            .disposed(by: rx.disposeBag)
        viewModel.currentDate
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] date in
                let dateComponents =  Calendar.current.dateComponents([.month,.year,.day], from:date)
                self.currentDay.text = String(dateComponents.day!)
                switch dateComponents.month{
                case 1:
                    self.currentMonth.image = #imageLiteral(resourceName: "JANUARY")
                case 2:
                    self.currentMonth.image = #imageLiteral(resourceName: "FEBRUARY")
                case 3:
                    self.currentMonth.image = #imageLiteral(resourceName: "APRIL")
                case 4:
                    self.currentMonth.image = #imageLiteral(resourceName: "MARCH")
                case 5:
                    self.currentMonth.image = #imageLiteral(resourceName: "MAY")
                case 6:
                    self.currentMonth.image = #imageLiteral(resourceName: "JUNE")
                case 7:
                    self.currentMonth.image = #imageLiteral(resourceName: "JULY")
                case 8:
                    self.currentMonth.image = #imageLiteral(resourceName: "AUGUST")
                case 9:
                    self.currentMonth.image = #imageLiteral(resourceName: "SEPTEMBER")
                case 10:
                    self.currentMonth.image = #imageLiteral(resourceName: "OCTOBER")
                case 11:
                    self.currentMonth.image = #imageLiteral(resourceName: "NOVEMBER")
                case 12:
                    self.currentMonth.image = #imageLiteral(resourceName: "DECEMBER")
                default:
                    viewModel.currentMonth.onError(UserError.unknown)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    func notificationBinding(){
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
            .subscribe(onNext:{ _ in
                    self.bottomConstraint.constant = 100
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        content.tintColor = #colorLiteral(red: 0.3982239962, green: 0.423751533, blue: 1, alpha: 1)
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
    func setGesture(){
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
}
extension CardManageViewController:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
