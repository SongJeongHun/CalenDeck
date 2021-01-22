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
}
extension Scene{
    func instantiate(from storyboard:String = "Main") -> UIViewController{
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        switch self{
        case .main(let timeLineViewModel,let deckViewModel):
            guard let mainTVC = storyboard.instantiateViewController(identifier: "main") as? UITabBarController else { fatalError() }
            guard var timeLineVC = storyboard.instantiateViewController(identifier: "timeLine") as? TimeLineViewController else { fatalError() }
            guard var deckVC = storyboard.instantiateViewController(identifier: "deck") as? DeckViewController else { fatalError() }
            timeLineVC.bind(viewModel: timeLineViewModel)
            deckVC.bind(viewModel: deckViewModel)
            return mainTVC
        }
    }
}
