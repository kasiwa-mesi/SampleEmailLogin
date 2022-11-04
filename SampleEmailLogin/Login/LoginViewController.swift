//
//  LoginViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/18.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> LoginViewController {
        guard let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() as? LoginViewController else {
            fatalError()
        }
        return vc
    }
}

private extension LoginViewController {
    @objc func tapLoginButton() {
        //ログイン処理を行う
        print("ログイン")
        
        guard let email = emailTextField.text else {
            fatalError()
        }
        
        guard let password = passwordTextField.text else {
            fatalError()
        }
        
        if let validationAlertMessage = Validator(email: emailTextField.text, password: passwordTextField.text, reconfirmPassword: nil, memoText: nil)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            AuthController.shared.signIn(email: email, password: password) { (isEmailVerified) in
                if isEmailVerified {
                    print("メールアドレス確認済み")
                    Router.shared.showHome(from: self)
                } else {
                    print("メールアドレス未確認")
                }
            }
        }
    }
}
