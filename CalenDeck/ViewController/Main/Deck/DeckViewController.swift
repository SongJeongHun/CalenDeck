//
//  DeckViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import UIKit
import RxSwift
import Action
import NSObject_Rx
import SideMenu
class DeckViewController: UIViewController,ViewControllerBindableType,SideMenuNavigationControllerDelegate{
    var viewModel:DeckViewModel!
    let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    @IBOutlet weak var indicator : UIActivityIndicatorView!
    @IBOutlet weak var currentCard:UIView!
    @IBOutlet weak var deckListButton:UIBarButtonItem!
    @IBOutlet weak var monthSelectButton:UIBarButtonItem!
    @IBOutlet weak var contentPanel:UIView!
    @IBOutlet weak var thumbnailPanel:UIView!
    @IBOutlet weak var thumbnailImage:UIImageView!
    @IBOutlet weak var content:UILabel!
    @IBOutlet weak var currentDay:UILabel!
    @IBOutlet weak var currentMonth:UIImageView!
    @IBOutlet weak var cardTitle:UILabel!
    var selectedDate = Date()
    override func viewDidLoad() {
        indicator.isHidden = true
        let date =  Calendar.current.dateComponents([.month,.year], from: Date())
        viewModel.selectedMonth = date.month!
        viewModel.selectedYear = date.year!
        viewModel.currentYear.onNext(date.year!)
        viewModel.currentMonth.onNext(date.month!)
        viewModel.cardStorage.getCardList(year: date.year!, month: date.month!)
            .subscribe(onCompleted:{
                self.viewModel.cardStorage.seletedModel.onNext(self.viewModel.cardStorage.cardList[0])
            })
            .disposed(by: rx.disposeBag)
        setUI()
        super.viewDidLoad()
    }
    func bindViewModel() {
        viewModel.cardStorage.seletedModel
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{[unowned self]card in
                indicator.isHidden = false
                indicator.startAnimating()
                let firstCard = card
                let dateComponents = Calendar.current.dateComponents([.month,.year,.day], from: firstCard.date)
                self.content.text = firstCard.content
                if firstCard.title == "카드가 없습니다!!"{
                    indicator.stopAnimating()
                    self.thumbnailImage.image = #imageLiteral(resourceName: "folder")
                    self.currentDay.text = String(0)
                }else{
                    self.viewModel.cardStorage.getThumbnail(card: card)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext:{img in
                            self.thumbnailImage.image = img
                            indicator.stopAnimating()
                            indicator.isHidden = true
                        })
//                    self.thumbnailImage.image = #imageLiteral(resourceName: "Image")
                    self.currentDay.text = String(dateComponents.day!)
                }
                self.cardTitle.text = firstCard.title
            })
            .disposed(by: rx.disposeBag)
        monthSelectButton.rx.action = viewModel.monthPickAction()
        deckListButton.rx.action = viewModel.showDeckListAction()
        ApplicationNotiCenter.sideMenuWillDisappear.addObserver()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{_ in
                self.shadowView.isHidden = true
            })
            .disposed(by: rx.disposeBag)
        ApplicationNotiCenter.sideMenuWillAppear.addObserver()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] menuWidth in
                guard let width = menuWidth as? CGFloat else { return }
                self.shadowView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - width, height: UIScreen.main.bounds.height)
                self.shadowView.isHidden = false
            })
            .disposed(by: rx.disposeBag)
        viewModel.currentMonth
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] month in
                switch month{
                case 1:
                    self.currentMonth.image = #imageLiteral(resourceName: "JANUARY")
                case 2:
                    self.currentMonth.image = #imageLiteral(resourceName: "FEBRUARY")
                case 3:
                    self.currentMonth.image = #imageLiteral(resourceName: "APRIL")
                case 4:
                    self.currentMonth.image = #imageLiteral(resourceName: "MARCH")
                case 5:
                    self.currentMonth.image = #imageLiteral(resourceName: "MAY")
                case 6:
                    self.currentMonth.image = #imageLiteral(resourceName: "JUNE")
                case 7:
                    self.currentMonth.image = #imageLiteral(resourceName: "JULY")
                case 8:
                    self.currentMonth.image = #imageLiteral(resourceName: "AUGUST")
                case 9:
                    self.currentMonth.image = #imageLiteral(resourceName: "SEPTEMBER")
                case 10:
                    self.currentMonth.image = #imageLiteral(resourceName: "OCTOBER")
                case 11:
                    self.currentMonth.image = #imageLiteral(resourceName: "NOVEMBER")
                case 12:
                    self.currentMonth.image = #imageLiteral(resourceName: "DECEMBER")
                default:
                    viewModel.currentMonth.onError(UserError.unknown)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        setShadowView()
        currentCard.layer.shadowRadius = 5.0
        currentCard.layer.shadowOffset = CGSize(width: 5, height: 5)
        currentCard.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        currentCard.layer.shadowOpacity = 0.6
        currentCard.layer.borderWidth = 0.5
        currentCard.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentPanel.layer.cornerRadius = 5.0
        thumbnailPanel.layer.cornerRadius = 5.0
        currentCard.layer.cornerRadius = 5.0
    }
    func setShadowView(){
        shadowView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        shadowView.layer.zPosition = 1
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.addSubview(shadowView)
        shadowView.isHidden = true
    }
}
