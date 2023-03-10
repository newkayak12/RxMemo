//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    var viewModel: MemoComposeViewModel!
    
    func bindViewModel() {
        viewModel.title.drive(navigationItem.rx.title).disposed(by: rx.disposeBag)
        viewModel.initialText.drive(contentTextView.rx.text).disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction//ActionLibaray  사용시 -> tab 하면 cancelAction이 동작
        saveButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
        
       let willShowObsevable =  NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue } //optionalUnwrapping
            .map{ $0.cgRectValue.height }
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map{ noti -> CGFloat in 0 }
        let keybaordObservable = Observable.merge(willShowObsevable, willHideObservable)
            .share()
            
        keybaordObservable
//            .withUnretained(contentTextView)
            .toContentInset(of: contentTextView)
//            .subscribe(onNext: { tv, height in
//                var inset = tv.contentInset
//                inset.bottom = height
//                tv.contentInset = inset
//
//                var scrollInset = tv.verticalScrollIndicatorInsets
//                scrollInset.bottom = height
//                tv.verticalScrollIndicatorInsets = scrollInset
//            })
            .bind(to: contentTextView.rx.contentInset)
            .disposed(by: rx.disposeBag)
        keybaordObservable.toScrollInset(of: contentTextView)
            .bind(to: contentTextView.rx.verticalScrollIndicatorInsets)
            .disposed(by: rx.disposeBag)
            
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contentTextView.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        contentTextView.resignFirstResponder()
    }
    
}

extension ObservableType where Element == CGFloat {
    func toContentInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map { height in
            var inset = textView.contentInset
            inset.bottom = height
            return inset
        }
    }
    func toScrollInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map { height in
            var scrollInset = textView.verticalScrollIndicatorInsets
            scrollInset.bottom = height
            return scrollInset
        }
    }
}
