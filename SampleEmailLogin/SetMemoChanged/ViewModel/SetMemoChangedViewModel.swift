//
//  SetMemoChangedViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/22.
//

import UIKit

protocol SetMemoChangedViewModelInput {
    func show(validationMessage: String)
}

protocol SetMemoChangedViewModelOutput {
    var memo: MemoModel { get }
}

final class SetMemoChangedViewModel: SetMemoChangedViewModelOutput {
    private var _memo: MemoModel
    var memo: MemoModel {
        get {
            return _memo
        }
    }
    
    private var input: SetMemoChangedViewModelInput!
    init(memo: MemoModel, input: SetMemoChangedViewModelInput) {
        self._memo = memo
        self.input = input
    }
    
    func updateMemo(memo: MemoModel) {
        if let validationAlertMessage = Validator(email: nil, password: nil, reconfirmPassword: nil, memoText: memo.text)?.alertMessage {
            input.show(validationMessage: validationAlertMessage)
        } else {
            if self.memo.text != memo.text {
                DatabaseService.shared.updateMemo(memo: memo) { (isUpdated) in
                    if isUpdated {
                        Router.shared.showReStart()
                    }
                }
            } else {
                Router.shared.showReStart()
            }
        }
    }
    
    func deleteMemo(memo: MemoModel) {
        DatabaseService.shared.deleteMemo(memo: memo) { isDeleted in
            if isDeleted {
                Router.shared.showReStart()
            }
        }
    }
}
