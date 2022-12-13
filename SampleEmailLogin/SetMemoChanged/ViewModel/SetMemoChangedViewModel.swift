//
//  SetMemoChangedViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/22.
//

import UIKit

protocol SetMemoChangedViewModelInput {
    func show(validationMessage: String)
    func showErrorAlert(code: String, message: String)
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
        if let validationAlertMessage = Validator(email: nil, password: nil, reconfirmPassword: nil, memoText: self.memo.text, updatedMemoText: memo.text)?.alertMessage {
            input.show(validationMessage: validationAlertMessage)
            return
        }
        
        DatabaseService.shared.updateMemo(memo: memo) { error in
            if let error {
                self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
                return
            }
            Router.shared.showReStart()
        }
    }
    
    func deleteMemo(memo: MemoModel) {
        DatabaseService.shared.deleteMemo(memo: memo) { error in
            if let error {
                self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
                return
            }
            Router.shared.showReStart()
        }
    }
}
