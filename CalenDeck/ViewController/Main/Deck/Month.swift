//
//  Month.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/17.
//

import Foundation
enum Month{
    case January
    case February
    case April
    case March
    case May
    case June
    case July
    case August
    case November
    case October
    case September
    case December
    var stringMonth:String{
        switch self {
        case .January:
            return "January"
        case .February:
            return "February"
        case .April:
            return "April"
        case .March:
            return "March"
        case .May:
            return "May"
        case .June:
            return "June"
        case .July:
            return "July"
        case .August:
            return "August"
        case .November:
            return "November"
        case .October:
            return "October"
        case .September:
            return "September"
        case .December:
            return "December"
        }
    }
}

