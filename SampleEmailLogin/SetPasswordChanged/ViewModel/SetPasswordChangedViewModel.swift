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
    private(set) var email: String
    
    init() {
        guard let email = AuthController.shared.getCurrentUser()?.email else {
            fatalError()
        }
        self.email = email
    }
    
    func passwordReset() {
        AuthController.shared.sendPasswordReset(email: self.email) { (onSubmitted) in
            if onSubmitted {
                Router.shared.showReStart()
            }
        }
    }
}
