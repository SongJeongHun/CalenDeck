//
//  LoginViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/27.
//

import UIKit
import RxSwift
import Action
import AuthenticationServices
class LoginViewController: UIViewController,ViewControllerBindableType {
    var viewModel:LoginViewModel!
    @IBOutlet weak var userID:UITextField!
    @IBOutlet weak var userPassword:UITextField!
    @IBOutlet weak var loginPanel:UIView!
    @IBOutlet weak var submit:UIButton!
    @IBOutlet weak var register:UIButton!
    @IBOutlet weak var findPassword:UIButton!
    @IBOutlet weak var loginStackView:UIStackView!
    @IBAction func authorizationApppleIDButtonPress(){
        let appleIDProvider =  ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    override func viewDidLoad() {
        setUI()
        super.viewDidLoad()
    }
    func setUI(){
        userID.layer.cornerRadius = 7.0
        loginPanel.layer.cornerRadius = 7.0
        userPassword.layer.cornerRadius = 7.0
        submit.layer.cornerRadius = 7.0
        register.layer.cornerRadius = 7.0
        findPassword.layer.cornerRadius = 7.0
        loginStackView.layer.cornerRadius = 7.0
        userPassword.isSecureTextEntry = true
    }
    func bindViewModel() {
        register.rx.action = viewModel.userJoinAction()
        submit.rx.tap
            .throttle(.milliseconds(5000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{_ in
                guard let id = self.userID.text else { return }
                guard let password = self.userPassword.text else { return }
                if id == "" || password == ""{
                    self.present(self.viewModel.loginFailAlert(),animated: true,completion: nil)
                }else{
                    self.viewModel.userStorage.login(userID:id , userPassword: password)
                        .subscribe(onCompleted:{
                            self.viewModel.loginSuccessAction(userID: id).execute()
                        }) { error in
                            self.present(self.viewModel.loginFailAlert(),animated: true,completion: nil)
                        }
                        .disposed(by: self.rx.disposeBag)
                }
            })
            .disposed(by: rx.disposeBag)
    }
}
