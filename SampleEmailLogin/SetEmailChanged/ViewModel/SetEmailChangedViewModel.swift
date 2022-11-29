//
//  SetEmailChangedViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/22.
//

import UIKit

protocol SetEmailChangedViewModelInput {
    func show(validationMessage: String)
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
    
    func updateEmail(newEmail: String, password: String, vc: UIViewController) {
        // バリデーションを走らせる
        if let validationAlertMessage = Validator(email: newEmail, password: nil, reconfirmPassword: nil, memoText: nil)?.alertMessage {
            input.show(validationMessage: validationAlertMessage)
        } else {
            // 再認証処理を走らせる
            let credential = AuthService.shared.getCredential(email: email, password: password)
            
            AuthService.shared.reAuthenticate(credential: credential) { (hasAuthentication) in
                if hasAuthentication {
                    AuthService.shared.updateEmail(email: newEmail) { (isUpdated) in
                        if isUpdated {
                            Router.shared.showReStart()
                        }
                    }
                } else {
                    let moveLoginAction = UIAlertAction(title: "ログイン画面に移動", style: .default) { _ in
                        Router.shared.showLogin(from: vc)
                    }
                    vc.showAlert(title: "直近でログインしていないため、もう一度行ってください", message: "", actions: [moveLoginAction])
                }
            }
        }
        
    }
}
