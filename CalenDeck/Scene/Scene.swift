//
//  Scene.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import Foundation
import UIKit
enum Scene{
    case main(TimeLineViewModel,DeckViewModel)
    case login(LoginViewModel)
    case join(JoinViewModel)
    case datePick(TimeLineViewModel)
    case deckList(DeckViewModel)
}
extension Scene{
    func instantiate(from storyboard:String = "Main") -> UIViewController{
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        switch self{
        case .main(let timeLineViewModel,let deckViewModel):
            //!!!!! 부모 뷰컨을 중심으로 흐름 잡기!!!!!!!!
            //하나하나 불러오면 로드 꼬임
            guard var mainTVC = storyboard.instantiateViewController(identifier: "Main") as? MainTabBarViewController else { fatalError() }
            guard var timeLineNC = mainTVC.viewControllers?.first as? UINavigationController else { fatalError() }
            guard var timeLineVC = timeLineNC.viewControllers.first as? TimeLineViewController else { fatalError() }
            guard var deckNav = mainTVC.viewControllers?.last as? UINavigationController else { fatalError() }
            guard var deckVC = deckNav.viewControllers.first as? DeckViewController else { fatalError() }
            timeLineVC.bind(viewModel: timeLineViewModel)
            deckVC.bind(viewModel: deckViewModel)
            return mainTVC
        case .login(let loginViewModel):
            guard var loginVC = storyboard.instantiateViewController(identifier: "login") as? LoginViewController else { fatalError() }
            loginVC.bind(viewModel: loginViewModel)
            return loginVC
        case .join(let joinViewModel):
            guard var joinVC = storyboard.instantiateViewController(identifier: "join") as? UserJoinViewController else { fatalError() }
            joinVC.bind(viewModel: joinViewModel)
            return joinVC
        case .datePick(let timeLineViewModel):
            guard var dateVC = storyboard.instantiateViewController(identifier: "datePick") as? DatePickViewController else { fatalError() }
            dateVC.bind(viewModel: timeLineViewModel)
            return dateVC
        case .deckList(let deckViewModel):
            guard let sideNav = storyboard.instantiateViewController(identifier: "SideNav") as? SideMenuNavigation else { fatalError() }
            guard var deckListVC = sideNav.viewControllers.first as? DeckListViewController else { fatalError() }
            deckListVC.bind(viewModel: deckViewModel)
            return sideNav
        }
    }
}
