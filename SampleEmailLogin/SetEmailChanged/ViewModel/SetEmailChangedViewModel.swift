//
//  SetEmailChangedViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/22.
//

import UIKit

protocol SetEmailChangedViewModelInput {
    func show(validationMessage: String)
    func showLoginAlert()
    func showErrorAlert(code: String, message: String)
}

protocol SetEmailChangedViewModelOutput {
    var email: String { get }
}

final class SetEmailChangedViewModel: SetEmailChangedViewModelOutput {
    private var _email: String
    var email: String {
        get {
            return _email
        }
    }
    
    private var input: SetEmailChangedViewModelInput!
    init(input: SetEmailChangedViewModelInput) {
        guard let email = AuthService.shared.getCurrentUser()?.email else {
            fatalError()
        }
        self._email = email
        self.input = input
    }
    
    func updateEmail(newEmail: String, password: String) {
        if let validationAlertMessage = Validator(email: newEmail, password: nil, reconfirmPassword: nil, memoText: nil, updatedMemoText: nil)?.alertMessage {
            input.show(validationMessage: validationAlertMessage)
            return
        }
        
        let credential = AuthService.shared.getCredential(email: email, password: password)
        AuthService.shared.reAuthenticate(credential: credential) { error in
            if let error {
                self.input.showLoginAlert()
                return
            }
        }
        AuthService.shared.updateEmail(email: newEmail) { error in
            if let error {
                self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
                return
            }
            Router.shared.showReStart()
        }
    }
    
}

