//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
//        DispatchQueue.main.async {
//            self.bindViewModel()
//        }
        bindViewModel()
    }
}
