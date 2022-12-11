//
//  RegisterViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/23.
//

import UIKit

protocol RegisterViewModelInput {
    func show(validationMessage: String)
    func showErrorAlert(code: String, message: String)
}

final class RegisterViewModel {
    private var input: RegisterViewModelInput!
    init(input: RegisterViewModelInput) {
        self.input = input
    }
    
    func createUser(email: String, password: String, reconfirmPassword: String) {
        if let validationAlertMessage = Validator(email: email, password: password, reconfirmPassword: reconfirmPassword, memoText: nil, updatedMemoText: nil)?.alertMessage {
            input.show(validationMessage: validationAlertMessage)
            return
        }
        
        AuthService.shared.createUser(email: email, password: password) { (error) in
            self.showErrorAlert(error: error)
            
            AuthService.shared.setLanguageCode(code: String.languageCode)
            AuthService.shared.sendEmailVerification { error in
                self.showErrorAlert(error: error)
            }
        }
    }
    
    private func showErrorAlert(error: NSError?) {
        if let error {
            let gotItAction = UIAlertAction(title: String.ok, style: .default)
            self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
}
