//
//  TimeLineViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import UIKit
import RxSwift
import NSObject_Rx
import RxCocoa
import FSCalendar
import Action

class TimeLineViewController: UIViewController,ViewControllerBindableType{
    var viewModel : TimeLineViewModel!
//    @IBOutlet weak var calendar:FSCalendar!
    @IBOutlet var timeLine:UITableView!
    @IBOutlet weak var testButton:UIBarButtonItem!
    override func viewDidLoad() {
        print("\(self) 메모리에 올라감->\(viewModel)")
        super.viewDidLoad()
    }
    func bindViewModel() {
        print("store구독")
        viewModel.eventStorage.store
            .bind(to:timeLine.rx.items){tableView,row,data in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as! TimeLineCell
                print("셀 생성")
                cell.content.text = data.content
                cell.mainTitle.text = data.mainTitle
                cell.subTitle.text = data.subTitle
                return cell
            }
            .disposed(by: rx.disposeBag)
    }
}
class TimeLineCell:UITableViewCell{
    @IBOutlet weak var mainTitle:UILabel!
    @IBOutlet weak var subTitle:UILabel!
    @IBOutlet weak var content:UILabel!
    @IBOutlet weak var panel:UIView!
    override func awakeFromNib() {
        panel.layer.cornerRadius = 7.0
        super.awakeFromNib()
    }
}

