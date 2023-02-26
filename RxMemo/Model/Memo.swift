//
//  Memo.swift
//  RxMemo
//
//  Created by Sang Hyeon kim on 2023/02/26.
//

import Foundation
struct Memo: Equatable {
    var contents: String
    var insertDate: Date
    var identity: String
    
    init(contents: String, insertDate: Date = Date()) {
        self.contents = contents
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    init(original: Memo, updateContent: String){
        self = original
        self.contents = updateContent
    }
}
