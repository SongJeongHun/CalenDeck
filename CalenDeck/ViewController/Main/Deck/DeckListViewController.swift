//
//  DeckListViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/11.
//
import UIKit
import SideMenu
import RxSwift
class DeckListViewController: UIViewController,ViewControllerBindableType,UITableViewDelegate{
    var formatter:DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd"
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    var viewModel:DeckViewModel!
    @IBOutlet weak var cardAddButton:UIBarButtonItem!
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var editButton:UIButton!
    @IBOutlet weak var selectedYear:UILabel!
    @IBOutlet weak var selectedMonth:UILabel!
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        setUI()
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let presentVC = self.presentingViewController {
            viewModel.sceneCoordinator.currentVC = presentVC
        }
        super.viewWillDisappear(animated)
    }
    func bindViewModel() {
        tableView.rx.modelSelected(Card.self)
            .subscribe(onNext:{ [unowned self] card in
                let firstIndex = self.viewModel.cardStorage.cardList.firstIndex(of: card)
                tableView.deselectRow(at: IndexPath(row: firstIndex!, section: 0),animated: true)
                self.viewModel.cardStorage.seletedModel.onNext(card)
            })
            .disposed(by: rx.disposeBag)
        editButton.rx.action = viewModel.deckEditButtonAction()
        viewModel.currentYear
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] year in
                let stringYear = String(year)
                self.selectedYear.text = stringYear
            })
            .disposed(by: rx.disposeBag)
        viewModel.currentMonth
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] month in
                switch month{
                case 1:
                    self.selectedMonth.text = "January"
                case 2:
                    self.selectedMonth.text = "February"
                case 3:
                    self.selectedMonth.text = "April"
                case 4:
                    self.selectedMonth.text = "March"
                case 5:
                    self.selectedMonth.text = "May"
                case 6:
                    self.selectedMonth.text = "June"
                case 7:
                    self.selectedMonth.text = "July"
                case 8:
                    self.selectedMonth.text = "August"
                case 9:
                    self.selectedMonth.text = "September"
                case 10:
                    self.selectedMonth.text = "October"
                case 11:
                    self.selectedMonth.text = "November"
                case 12:
                    self.selectedMonth.text = "December"
                default:
                    viewModel.currentMonth.onError(UserError.unknown)
                }
            })
            .disposed(by: rx.disposeBag)
        viewModel.cardStorage.store
            .bind(to:tableView.rx.items){tableView,row,data in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell") as? CardListCell else { return UITableViewCell() }
                cell.day.text = self.formatter.string(from: data.date)
                cell.title.text = data.title
                return cell
            }
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        headerView.layer.cornerRadius = 7.0
        headerView.layer.borderWidth = 0.5
        headerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 7.0
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editButton.layer.zPosition = 101
    }
}
class CardListCell:UITableViewCell{
    @IBOutlet weak var panel:UIView!
    @IBOutlet weak var day:UILabel!
    @IBOutlet weak var title:UILabel!
    override func awakeFromNib() {
        panel.layer.borderWidth = 0.5
        panel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        panel.layer.cornerRadius = 7.0
        super.awakeFromNib()
    }
}

