//
//  LoginViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/23.
//

import UIKit

final class LoginViewModel {
    func signIn(email: String, password: String, vc: UIViewController) {
        if let validationAlertMessage = Validator(email: email, password: password, reconfirmPassword: nil, memoText: nil)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            vc.showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            FirebaseAuthService.shared.signIn(email: email, password: password)
        }
    }
}
