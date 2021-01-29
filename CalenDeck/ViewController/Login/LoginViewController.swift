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
    @IBOutlet weak var loginPanel:UIView!
    @IBOutlet weak var userPassword:UITextField!
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
    }
}
