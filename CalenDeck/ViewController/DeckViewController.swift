//
//  DeckViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import UIKit

class DeckViewController: UIViewController,ViewControllerBindableType {
    var viewModel:DeckViewModel!
    @IBOutlet weak var currentCard:UIView!
    override func viewDidLoad() {
        currentCard.layer.cornerRadius = 5.0
        super.viewDidLoad()
    }
    func bindViewModel() {
    
    }
}
