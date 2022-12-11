//
//  LoginViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/23.
//

import UIKit

protocol LoginViewModelInput {
    func show(validationMessage: String)
    func showErrorAlert(code: String, message: String)
}

final class LoginViewModel {
    private var input: LoginViewModelInput!
    init(input: LoginViewModelInput) {
        self.input = input
    }
    
    func signIn(email: String, password: String) {
        if let validationAlertMessage = Validator(email: email, password: password, reconfirmPassword: nil, memoText: nil, updatedMemoText: nil)?.alertMessage {
            input.show(validationMessage: validationAlertMessage)
            return
        }
        
        AuthService.shared.signIn(email: email, password: password) { error in
            guard let error else {
                return
            }
            
            let gotItAction = UIAlertAction(title: String.ok, style: .default)
            self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
}
