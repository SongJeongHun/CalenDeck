//
//  MonthPickViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/15.
//
import RxSwift
import NSObject_Rx
import Action
import UIKit

class MonthPickViewController: UIViewController,ViewControllerBindableType{
    var viewModel:DeckViewModel!
    @IBOutlet weak var monthPicker:UIDatePicker!
    @IBOutlet weak var okButton:UIButton!
    @IBOutlet weak var cancelButton:UIButton!
    @IBOutlet weak var buttonWidthConstraint:NSLayoutConstraint!
    override func viewDidLoad() {
        setUI()
        super.viewDidLoad()
    }
    func bindViewModel() {
        okButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{_ in
                let date = self.monthPicker.date
                self.viewModel.currentDate = date
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: rx.disposeBag)
        cancelButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{_ in
                
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM"
        let stringDate = dateFormatter.string(from: monthPicker.date)
        buttonWidthConstraint.constant = UIScreen.main.bounds.width / 2
    }
}
