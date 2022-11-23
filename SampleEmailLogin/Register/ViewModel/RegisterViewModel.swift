//
//  RegisterViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/23.
//

import UIKit

final class RegisterViewModel {
    func createUser(email: String, password: String, reconfirmPassword: String, vc: UIViewController) {
        if let validationAlertMessage = Validator(email: email, password: password, reconfirmPassword: reconfirmPassword, memoText: nil)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            vc.showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            FirebaseAuthService.shared.createUser(email: email, password: password) { (userExists) in
                if userExists {
                    FirebaseAuthService.shared.setLanguageCode(code: "ja_JP")
                    FirebaseAuthService.shared.sendEmailVerification()
                }
            }
        }
    }
}
