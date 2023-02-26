//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable //구독자를 추가하고 화면 전환이 완료된 뒤에 필요한 작업을 하면 된다. 
}
