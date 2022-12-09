//
//  RegisterViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/23.
//

import UIKit

protocol RegisterViewModelInput {
    func show(validationMessage: String)
}

final class RegisterViewModel {
    private var input: RegisterViewModelInput!
    init(input: RegisterViewModelInput) {
        self.input = input
    }
    
    func createUser(email: String, password: String, reconfirmPassword: String) {
        if let validationAlertMessage = Validator(email: email, password: password, reconfirmPassword: reconfirmPassword, memoText: nil, updatedMemoText: nil)?.alertMessage {
            input.show(validationMessage: validationAlertMessage)
        } else {
            AuthService.shared.createUser(email: email, password: password) { (userExists) in
                if userExists {
                    AuthService.shared.setLanguageCode(code: String.languageCode)
                    AuthService.shared.sendEmailVerification()
                }
            }
        }
    }
}
