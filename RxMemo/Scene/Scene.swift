//
//  Scene.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import UIKit

enum Scene {
    case list(MemoListViewModel), detail(MemoDetailViewModel), compose(MemoComposeViewModel)
}

//router?
extension Scene {
    func instantiate(from storyBoard: String = "Main") -> UIViewController {
        let storyBoard = UIStoryboard(name: storyBoard, bundle: nil)
        
        switch self {
            case .list(let memoListViewModel):
                guard let nav = storyBoard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else { fatalError() }
                guard var listVC = nav.viewControllers.first as? MemoListViewController else { fatalError() }
                DispatchQueue.main.async {
                    listVC.bind(viewModel: memoListViewModel)
                }
                return nav
            case .detail(let memoDetailViewModel):
                guard var detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else { fatalError() }
                DispatchQueue.main.async {
                    detailVC.bind(viewModel: memoDetailViewModel)
                }
                return detailVC
            case .compose(let memoComposeViewModel):
                guard let nav = storyBoard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else { fatalError() }
                guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else { fatalError() }
                DispatchQueue.main.async {
                    composeVC.bind(viewModel: memoComposeViewModel)
                }
                return nav
        }
    }
    
}
