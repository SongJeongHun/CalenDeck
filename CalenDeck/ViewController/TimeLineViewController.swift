//
//  TimeLineViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import UIKit
import RxSwift
import NSObject_Rx
import FSCalendar
class TimeLineViewController: UIViewController ,ViewControllerBindableType{
    var viewModel : TimeLineViewModel!
    @IBOutlet weak var calendar:FSCalendar!
    @IBOutlet weak var timeLine:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func bindViewModel() {
        
    }
}
