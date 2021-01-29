//
//  UserJoinViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/29.
//

import UIKit
import RxSwift
class UserJoinViewController: UIViewController,ViewControllerBindableType {
    var viewModel:JoinViewModel!
    @IBOutlet weak var userID:UITextField!
    @IBOutlet weak var userPassword:UITextField!
    @IBOutlet weak var userPasswordConfirm:UITextField!
    @IBOutlet weak var userEmail:UITextField!
    override func viewWillAppear(_ animated: Bool) {
        setUI()
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = presentingViewController!
        super.viewWillDisappear(animated)
    }
    func bindViewModel() {
        userID.rx.text
            .subscribe(onNext:{text in
                if let ID = text{
                    if ID.count > 3{
                        self.userID.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    }else{
                        self.userID.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        Observable.combineLatest(userPassword.rx.text,userPasswordConfirm.rx.text)
            .subscribe(onNext:{pwd,pwdConfirm in
                if let password = pwd, let passwordConfirm = pwdConfirm{
                    if password != passwordConfirm{
                        self.userPasswordConfirm.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    }
                    if password.count > 6{
                        if password == passwordConfirm{
                            self.userPasswordConfirm.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                        }
                        self.userPassword.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    }else{
                        self.userPassword.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        userPassword.isSecureTextEntry = true
        userPasswordConfirm.isSecureTextEntry = true
        userPassword.layer.cornerRadius = 5.0
        userPasswordConfirm.layer.cornerRadius = 5.0
        userID.layer.cornerRadius = 5.0
        userEmail.layer.cornerRadius = 5.0
        userID.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        userID.layer.borderWidth = 1.0
        userPasswordConfirm.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        userPasswordConfirm.layer.borderWidth = 1.0
        userPassword.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        userPassword.layer.borderWidth = 1.0
        userEmail.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        userEmail.layer.borderWidth = 1.0
    }
}
