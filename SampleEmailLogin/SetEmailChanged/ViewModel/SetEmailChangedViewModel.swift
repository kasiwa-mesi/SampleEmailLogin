//
//  SetEmailChangedViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/22.
//

import UIKit

final class SetEmailChangedViewModel {
    func updateEmail(email: String, newEmail: String, password: String, vc: UIViewController) {
        // バリデーションを走らせる
        if let validationAlertMessage = Validator(email: newEmail, password: nil, reconfirmPassword: nil, memoText: nil)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            vc.showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            // 再認証処理を走らせる
            let credential = AuthController.shared.getCredential(email: email, password: password)
            
            AuthController.shared.reAuthenticate(credential: credential) { (hasAuthentication) in
                if hasAuthentication {
                    print(hasAuthentication)
                    AuthController.shared.updateEmail(email: newEmail) { (isUpdated) in
                        if isUpdated {
                            Router.shared.showReStart()
                        }
                    }
                } else {
                    print("もう一度ログインしてください")
                    let moveLoginAction = UIAlertAction(title: "ログイン画面に移動", style: .default) { _ in
                        Router.shared.showLogin(from: vc)
                    }
                    vc.showAlert(title: "直近でログインしていないため、もう一度行ってください", message: "", actions: [moveLoginAction])
                }
            }
        }
        
    }
}