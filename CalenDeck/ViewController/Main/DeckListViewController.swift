//
//  DeckListViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/11.
//
import UIKit
import SideMenu
class DeckListViewController: UIViewController,ViewControllerBindableType{
    var viewModel:DeckViewModel!
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var editButton:UIButton!
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        setUI()
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = presentingViewController!
        super.viewWillDisappear(animated)
    }
    func bindViewModel() {
        viewModel.cardStorage.store
            .bind(to:tableView.rx.items){tableView,row,data in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell") as? CardListCell else { return UITableViewCell() }
                cell.day.text = self.viewModel.cardStorage.formatter.string(from: data.date)
                cell.title.text = data.content
                return cell
            }
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        headerView.layer.cornerRadius = 7.0
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
        super.awakeFromNib()
    }
}
