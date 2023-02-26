//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import Foundation
import RxSwift
import RxCocoa
import Action


class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.storage.createMemo(content: "")
                .flatMap { memo -> Observable<Void> in
                    let composeViewModel = MemoComposeViewModel(title: "새 메모",
                                                                sceneCoordinator: self.sceneCoordinator,
                                                                storage: self.storage,
                                                                saveAction: self.performUpdate(memo: memo),
                                                                cancelAction: self.perfomCancel(memo: memo))
                    let composeScene = Scene.compose(composeViewModel)
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                        .asObservable()
                        .map { _ in }
            }
        }
    }
                                            //입   , 출
    func performUpdate(memo: Memo) -> Action<String,Void> {
        return Action { input in
            return self.storage.update(memo: memo, content: input).map { _ in }
        }
    }
    
    func perfomCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map { _ in }
        }
    }
    //lazy -> closure 내부에서 self 접근
    lazy var detailAction: Action<Memo, Void> = {
        return Action { memo in
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage )
            let detailScene = Scene.detail(detailViewModel)
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true)
                .asObservable()
                .map{ _ in }
        }
    }()
    
//    lazy var popAction = CocoaAction { [unowned self] in
//        return self.sceneCoordinator.close(animated: true)
//            .asObservable()
//            .map{ _ in }
//    }
}
