//
//  Card.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import Foundation
import UIKit
struct Card:Equatable{
    var year:Int
    var month:Int
    var day:Int
    var title:String
    var content:String
    var thumbnail:UIImage?
    var grade:Int = 0
    init(year:Int,month:Int,day:Int,title:String,content:String,thumbnail:UIImage?){
        self.year = year
        self.month = month
        self.day = day
        self.title = title
        self.content = content
        self.thumbnail = thumbnail
    }
    
}
