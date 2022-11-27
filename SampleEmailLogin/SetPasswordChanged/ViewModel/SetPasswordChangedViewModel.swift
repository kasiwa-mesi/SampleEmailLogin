//
//  SetPasswordChangedViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/22.
//

import Foundation

protocol SetPasswordChangedViewModelOutput {
    var email: String { get }
}

final class SetPasswordChangedViewModel: SetPasswordChangedViewModelOutput {
    private var _email: String
    var email: String {
        get {
            return _email
        }
    }
    
    init() {
        guard let email = AuthService.shared.getCurrentUser()?.email else {
            fatalError()
        }
        self._email = email
    }
    
    func passwordReset() {
        AuthService.shared.sendPasswordReset(email: self.email) { (onSubmitted) in
            if onSubmitted {
                Router.shared.showReStart()
            }
        }
    }
}
