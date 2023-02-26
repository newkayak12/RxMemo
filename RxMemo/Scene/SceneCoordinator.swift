//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import Foundation
import RxSwift
import RxCocoa
extension UIViewController {
    var sceneViewController: UIViewController{
        return self.children.last ?? self
    }
}
class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    //window, 현재 화면의 Scene
    
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow){
        self.window = window
        currentVC = window.rootViewController!
    }
    
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> RxSwift.Completable {
        let subject = PublishSubject<Never>() //성공 실패만 방출 next 필요 없음
        let target = scene.instantiate()
        
        switch style {
            case .root:
                currentVC = target.sceneViewController
                window.rootViewController = target
                subject.onCompleted()
            case .push:
                
                guard let nav = currentVC.navigationController else {
                    subject.onError(TransitionError.navigationControllerMissing)
                    break;
                }
                nav.rx.willShow
                    .withUnretained(self)
                    .subscribe(onNext: { (coordinator, evt) in
                        coordinator.currentVC = evt.viewController.sceneViewController
                    
                    }).disposed(by: bag)
                
                nav.pushViewController(target, animated: animated)
                currentVC = target.sceneViewController
                subject.onCompleted()
            case .modal:
                
                
                currentVC.present(target, animated: animated) {//completionHandler
                    subject.onCompleted()
                }
                currentVC = target.sceneViewController
                
        }
        
        return subject.asCompletable()
    }
    
    @discardableResult
    func close(animated: Bool) -> RxSwift.Completable {
        return Completable.create {
            [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                
                self.currentVC = nav.viewControllers.last!.sceneViewController
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
    
    
}
