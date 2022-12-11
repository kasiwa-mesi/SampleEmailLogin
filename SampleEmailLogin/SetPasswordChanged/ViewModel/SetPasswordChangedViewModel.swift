//
//  SetPasswordChangedViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/22.
//

import UIKit

protocol SetPasswordChangedViewModelOutput {
    var email: String { get }
}

protocol SetPasswordChangedViewModelInput {
    func showErrorAlert(code: String, message: String)
}

final class SetPasswordChangedViewModel: SetPasswordChangedViewModelOutput {
    private var _email: String
    var email: String {
        get {
            return _email
        }
    }
    
    private var input: SetPasswordChangedViewModelInput!
    init(input: SetPasswordChangedViewModelInput) {
        guard let email = AuthService.shared.getCurrentUser()?.email else {
            fatalError()
        }
        self._email = email
        self.input = input
    }
    
    func passwordReset() {
        AuthService.shared.sendPasswordReset(email: self.email) { error in
            guard let error else {
                Router.shared.showReStart()
                return
            }
            
            self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
}
