//
//  User.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/29.
//

import Foundation
struct User :Equatable{
    var userID:String
    var userPassword:String
    var userEmail:String
    init(userID:String,userPassword:String,userEmail:String){
        self.userID = userID
        self.userPassword = userPassword
        self.userEmail = userEmail
    }
}
enum UserError:Error{
    case userIDMissing
    case userPasswordMissing
    case unknown
}

