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
    func showLoginAlert()
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
        let email = AuthService.shared.getCurrentUserEmail()
        self._email = email ?? ""
        self.input = input
    }
    
    func passwordReset() {
        AuthService.shared.sendPasswordReset(email: self.email) { error in
            if let error {
                self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
                return
            }
            
            Router.shared.showReStart()
        }
    }
    
    func isLogined() {
        if email.isEmpty {
            self.input.showLoginAlert()
        }
    }
    
    func logOut() {
        AuthService.shared.signOut { error in
            self.showErrorAlert(error: error)
        }
    }
    
    private func showErrorAlert(error: NSError?) {
        if let error {
            self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
}
