//
//  DatePickViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/07.
//

import UIKit
import RxSwift
import Action
import NSObject_Rx
class DatePickViewController: UIViewController,ViewControllerBindableType{
    var viewModel:TimeLineViewModel!
    @IBOutlet weak var datePicker:UIDatePicker!
    @IBOutlet weak var okButton:UIButton!
    @IBOutlet weak var cancelButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func bindViewModel() {
        okButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{_ in
                let date = self.datePicker.date
                self.viewModel.selectedDate.onNext(date)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
}
