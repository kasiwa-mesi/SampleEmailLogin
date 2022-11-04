//
//  SetEmailChangedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/25.
//

import UIKit

final class SetEmailChangedViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailChangeButton: UIButton! {
        didSet {
            emailChangeButton.addTarget(self, action: #selector(tapEmailChangeButton), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> SetEmailChangedViewController {
        guard let vc = UIStoryboard.init(name: "SetEmailChanged", bundle: nil).instantiateInitialViewController() as? SetEmailChangedViewController else {
            fatalError()
        }
        return vc
    }
}

private extension SetEmailChangedViewController {
    @objc func tapEmailChangeButton() {
        print("Emailを変更する")
        guard let email = AuthController.shared.getCurrentUser()?.email else {
            fatalError()
        }
        
        guard let newEmail = emailTextField.text else {
            fatalError()
        }
        
        guard let password = passwordTextField.text else {
            fatalError()
        }
        
        print(email)
        print(password)
        print(newEmail)
        
        // バリデーションを走らせる
        if let validationAlertMessage = Validator(email: newEmail, password: nil, reconfirmPassword: nil, memoText: nil)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
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
                        Router.shared.showLogin(from: self)
                    }
                    self.showAlert(title: "直近でログインしていないため、もう一度行ってください", message: "", actions: [moveLoginAction])
                }
            }
        }
    }
}
