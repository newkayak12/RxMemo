//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {
    private var list = [
        Memo(content: "Hello, RxSwift",insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Hello, RxCocoa",insertDate: Date().addingTimeInterval(-20))
    ]
    //이 배열은 Observable을 통해서 외부에 공개
    //배열의 상태가 업데이트되면 next를 방출해야
    //초기 더미를 방출해야하니 Behavior
    //Rx에서 테이블 뷰 업데이트는 next를 해야 reload됨
    
    
    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)
    
    private lazy var store = BehaviorSubject<[MemoSectionModel]>(value: [sectionModel])
    
    @discardableResult
    func createMemo(content: String) -> RxSwift.Observable<Memo> {
        let memo = Memo(content: content)
        sectionModel.items.insert(memo, at: 0)
        store.onNext([sectionModel]) //리스트에서 next
        return Observable.just(memo) //결과 값 Observable
    }
    
    @discardableResult
    func memoList() -> RxSwift.Observable<[MemoSectionModel]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
        let updated = Memo(original: memo, updateContent: content)
        if let index = sectionModel.items.firstIndex(where:  { $0 == memo }) {
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updated, at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> RxSwift.Observable<Memo> {
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
        }
        store.onNext([sectionModel])

        return Observable.just(memo)
    }
    
    
}
