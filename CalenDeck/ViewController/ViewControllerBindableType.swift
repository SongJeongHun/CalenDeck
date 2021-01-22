//
//  ViewControllerBindableType.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//
import UIKit
protocol ViewControllerBindableType {
    associatedtype viewModelType
    var viewModel:viewModelType!{get set}
    func bindViewModel()
}
extension ViewControllerBindableType where Self:UIViewController{
    mutating func bind(viewModel:Self.viewModelType){
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
