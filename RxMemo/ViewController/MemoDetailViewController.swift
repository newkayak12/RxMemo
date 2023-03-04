//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import UIKit
import RxSwift

class MemoDetailViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var viewModel: MemoDetailViewModel!
    func bindViewModel() {
        viewModel.title.drive(navigationItem.rx.title).disposed(by: rx.disposeBag)
        viewModel.contents.bind(to: contentTableView.rx.items) { tableView, row, value in
            switch row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()
            }
        }.disposed(by: rx.disposeBag)
        
//          대체하지만 굉장히 어색하다.
//        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//        viewModel.title
//            .drive(backButton.rx.title)
//            .disposed(by: rx.disposeBag)
//        backButton.rx.action = viewModel.popAction
//        //        navigationItem.backBarButtonItem = backButton //action이 대체되지 않는다.
//        navigationItem.hidesBackButton = true //숨기고 새로 추가
//        navigationItem.leftBarButtonItem = backButton
        
        
        editButton.rx.action = viewModel.makeEditAction()
        //편집은 action
        
        //공유는 tap...? 이걸 action으로 바꿔보기?
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler:MainScheduler.instance )
            .withUnretained(self)
            .subscribe(onNext : { vc, _ in
                let memo = vc.viewModel.memo.content
                let activityVC = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                vc.present(activityVC, animated: true)
            }).disposed(by: rx.disposeBag)
        
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

