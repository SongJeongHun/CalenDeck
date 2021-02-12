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
            
    }
    func setUI(){
        headerView.layer.cornerRadius = 7.0
        tableView.separatorStyle = .none
        editButton.layer.zPosition = 101
    }
   
}
