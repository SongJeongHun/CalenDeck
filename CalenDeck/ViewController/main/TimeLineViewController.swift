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
        viewModel.eventStorage.createEvent(style: .create(Card(date: Date(), title: "test", content: "test", thumbnail: nil)))
        viewModel.eventStorage.createEvent(style: .follow("jongkun030"))
        viewModel.eventStorage.getTimeLine()
            .subscribe(onCompleted: {
                print(self.viewModel.eventStorage.eventList)
            }, onError: {error in
                print(error)
            })
    }
}
class TimeLineCell:UITableViewCell{
    @IBOutlet weak var mainTitle:UILabel!
    @IBOutlet weak var subTitle:UILabel!
    @IBOutlet weak var content:UILabel!
}
