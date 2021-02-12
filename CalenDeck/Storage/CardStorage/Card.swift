//
//  Card.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import Foundation
import UIKit
struct Card:Equatable{
    var date:Date
    var title:String
    var content:String
    var thumbnail:UIImage?
    var grade:Int = 0
    init(date:Date,title:String,content:String,thumbnail:UIImage?){
        self.date = date
        self.title = title
        self.content = content
        self.thumbnail = thumbnail
    }
    
}
