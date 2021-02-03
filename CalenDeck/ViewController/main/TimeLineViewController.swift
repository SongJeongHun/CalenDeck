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
    @IBAction func refreshAction(refresh:UIRefreshControl){
        refresh.endRefreshing()
        timeLine.reloadData()
    }
    override func viewDidLoad() {
        refreshControl()
        super.viewDidLoad()
    }
    func refreshControl(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshAction(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침 중")
        timeLine.refreshControl = refresh
    }
    func bindViewModel() {
        print("store구독")
        viewModel.eventStorage.store
            .bind(to:timeLine.rx.items){tableView,row,data in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as! TimeLineCell
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

