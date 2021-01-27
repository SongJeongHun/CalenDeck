//
//  AppleLoginViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/27.
//

import UIKit
import AuthenticationServices

extension LoginViewController:ASAuthorizationControllerDelegate{
    func setAppleAuthorization(){
        let authorizatinButton = ASAuthorizationAppleIDButton()
        authorizatinButton.addTarget(self, action:#selector(authorizationApppleIDButtonPress) , for: .touchUpInside)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential{
            let userIdentifier = appleIDCredential.user
            let userfirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
        }else if let passwordCredential = authorization.credential as? ASPasswordCredential{
            let username = passwordCredential.user
            let password = passwordCredential.password
        }
    }
}
extension LoginViewController:ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
