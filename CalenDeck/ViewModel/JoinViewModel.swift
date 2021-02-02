//
//  JoinViewModel.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/29.
//

import Foundation
import Action
import RxSwift
class JoinViewModel:ViewModeltype{
    var userStorage = UserStorage()
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
