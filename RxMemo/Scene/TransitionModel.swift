//
//  TransitionModel.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import Foundation

enum TransitionStyle {
    case root, push, modal
}

enum TransitionError: Error {
    case navigationControllerMissing, cannotPop, unknown
}
