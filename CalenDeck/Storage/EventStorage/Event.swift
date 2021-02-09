//
//  Event.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/26.
//

import Foundation
struct Event:Equatable{
    var style:EventStyle
    var mainTitle:String
    var subTitle:String
    var content:String
    var owner:String
    var time:String
    init(style:EventStyle,mainTitle:String,subTitle:String,content:String,owner:String,time:String){
        self.style = style
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.content = content
        self.owner = owner
        self.time = time
    }
    init(empty style:EventStyle){
        self.style = .empty
        self.mainTitle = "empty"
        self.subTitle = ""
        self.content = ""
        self.owner = ""
        self.time = ""
    }
}
enum EventStyle:Equatable{
    case create(Card)
    case follow(String)
    case empty
}
