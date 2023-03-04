//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    var viewModel: MemoListViewModel!
    
    func bindViewModel() {
        viewModel.title.drive(navigationItem.rx.title).disposed(by: rx.disposeBag)
        
        viewModel.memoList
//            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
//                cell.textLabel?.text = memo.content
//            }
            .bind(to: listTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: rx.disposeBag)
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            .withUnretained(self) //self에 대한 비소유 참조 + zip에 결과가 튜플로 재반환
            .do(onNext: { /*[ unowned self ]*/ ( vc, data ) in
                vc.listTableView.deselectRow(at: data.1, animated: true)
            })
            .map { $1.0 }
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
        
//        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//        viewModel.title
//            .drive(backButton.rx.title)
//            .disposed(by: rx.disposeBag)
//        backButton.rx.action = viewModel.popAction
////        navigationItem.backBarButtonItem = backButton //action이 대체되지 않는다.
//        navigationItem.hidesBackButton = true //숨기고 새로 추가
//        navigationItem.leftBarButtonItem = backButton
        
        
        
        listTableView.rx.modelDeleted(Memo.self) //controlEvent를 리턴
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

}
