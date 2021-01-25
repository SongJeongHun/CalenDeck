//
//  TransitionStyle.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import Foundation
enum TransitionStyle{
    case root
    case push
    case modal
}
enum TransitionError:Error{
    case navigationMissing
    case cannotPop
    case unKnown    
}
