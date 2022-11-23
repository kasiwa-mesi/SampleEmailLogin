//
//  SetMemoChangedViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/22.
//

import UIKit

protocol SetMemoChangedViewModelOutput {
    var memo: MemoModel { get }
}

final class SetMemoChangedViewModel: SetMemoChangedViewModelOutput {
    private(set) var memo: MemoModel
    
    init(memo: MemoModel) {
        self.memo = memo
    }
    
    func updateMemo(memo: MemoModel, vc: UIViewController) {
        if let validationAlertMessage = Validator(email: nil, password: nil, reconfirmPassword: nil, memoText: memo.text)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            vc.showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            if self.memo.text != memo.text {
                CloudFirestoreService.shared.updateMemo(memo: memo) { (isUpdated) in
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
        CloudFirestoreService.shared.deleteMemo(memo: memo) { isDeleted in
            if isDeleted {
                Router.shared.showReStart()
            }
        }
    }
}
