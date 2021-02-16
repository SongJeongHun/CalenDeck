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
    @IBOutlet weak var currentDate:UILabel!
//    var dateArray:Set<String> = []
    @IBOutlet weak var calendar:FSCalendar!
    @IBOutlet weak var datePickButton:UIBarButtonItem!
    @IBOutlet var timeLine:UITableView!
    @IBOutlet weak var calendarHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var foldButton:UIBarButtonItem!
    override func viewDidLoad() {
        timeLine.rx.setDelegate(self).disposed(by: rx.disposeBag)
        addRefreshController()
        calendarSet()
        setUI()
        super.viewDidLoad()
    }
    func setUI(){
        timeLine.layer.cornerRadius = 5.0
        timeLine.layer.shadowRadius = 2.0
        timeLine.layer.shadowOffset = CGSize(width: 2, height: 3)
        timeLine.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        timeLine.layer.shadowOpacity = 0.2
    }
    func bindViewModel() {
        viewModel.selectedDate
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] date in
                let stringDate = viewModel.eventStorage.formatter.string(from: date)
                viewModel.selectedDateString = stringDate
                if let selectedDate = calendar.selectedDate{
                    calendar.deselect(selectedDate)
                }
                calendar.select(date)
                calendar.adjustMonthPosition()
                currentDate.text = stringDate
                viewModel.eventStorage.getTimeLine(to: date)
            })
            .disposed(by: rx.disposeBag)
        foldButton.rx.action = foldAction()
        viewModel.eventStorage.store
            .bind(to:timeLine.rx.items){tableView,row,data in
                if data.style == .empty{
                    self.timeLine.separatorStyle = .none
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyCell
                    return cell
                }else{
                    self.timeLine.separatorStyle = .singleLine
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as! TimeLineCell
                    cell.content.text = data.content
                    cell.mainTitle.text = data.mainTitle
                    cell.subTitle.text = data.subTitle
                    return cell
                }
            }
            .disposed(by: rx.disposeBag)
        datePickButton.rx.action = viewModel.datePickAction()
    }
    @IBAction func refreshAction(refresh:UIRefreshControl){
        viewModel.eventStorage.getTimeLine(to: viewModel.eventStorage.formatter.date(from: viewModel.selectedDateString) ?? Date())
            .subscribe(onCompleted:{
                self.timeLine.reloadData()
                refresh.endRefreshing()
            })
            .disposed(by: rx.disposeBag)
    }
    func addRefreshController(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshAction(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침 중")
        timeLine.refreshControl = refresh
    }
}
extension TimeLineViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
class TimeLineCell:UITableViewCell{
    @IBOutlet weak var mainTitle:UILabel!
    @IBOutlet weak var subTitle:UILabel!
    @IBOutlet weak var content:UILabel!
    @IBOutlet weak var panel:UIView!
    @IBOutlet weak var backgroundPanel:UIView!
    override func awakeFromNib() {
        backgroundPanel.layer.cornerRadius = 7.0
        panel.layer.cornerRadius = 7.0
        super.awakeFromNib()
    }
}
class EmptyCell:UITableViewCell{
    @IBOutlet weak var panel:UIView!
    override func awakeFromNib() {
        panel.layer.cornerRadius = 7.0
        super.awakeFromNib()
    }
}

