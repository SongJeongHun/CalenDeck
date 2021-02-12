//
//  SideMenuNavigation.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/11.
//

import UIKit
import SideMenu
class SideMenuNavigation:SideMenuNavigationController,SideMenuNavigationControllerDelegate{
    override func viewDidLoad(){
        sideMenuDelegate = self
        self.presentationStyle = .menuSlideIn
        self.isNavigationBarHidden = true
        super.viewDidLoad()
    }
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        ApplicationNotiCenter.sideMenuWillAppear.post(object: self.menuWidth)
    }
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        ApplicationNotiCenter.sideMenuWillDisappear.post()
    }
}
