//
//  RegisterViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/18.
//

import UIKit
import FirebaseAuth

final class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var reconfirmPasswordTextField: UITextField!
    
    @IBOutlet weak var moveLoginScreenButton: UIButton! {
        didSet {
            moveLoginScreenButton.addTarget(self, action: #selector(tapMoveLoginScreenButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.addTarget(self, action: #selector(tapRegisterButton), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> RegisterViewController {
        guard let vc = UIStoryboard.init(name: "Register", bundle: nil).instantiateInitialViewController() as? RegisterViewController else {
            fatalError()
        }
        return vc
    }
}

private extension RegisterViewController {
    @objc func tapMoveLoginScreenButton() {
        Router.shared.showLogin(from: self)
    }
    
    @objc func tapRegisterButton() {
        //会員登録処理を行う
        print("会員登録する")
        // ログイン処理を走らせる前に、email, passwordのアンラップを先に行う
        guard let email = emailTextField.text else {
            fatalError()
        }
        
        guard let password = passwordTextField.text else {
            fatalError()
        }
        
        guard let reconfirmPassword = reconfirmPasswordTextField.text else {
            fatalError()
        }
        
        if let validationAlertMessage = Validator(email: emailTextField.text, password: passwordTextField.text, reconfirmPassword: reconfirmPassword, memoText: nil)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let user = authResult?.user {
                    print(user)
                    Auth.auth().languageCode = "ja_JP"
                    user.sendEmailVerification(completion: { error in
                        if error == nil {
                            print("メールが送信できました！")
                            Router.shared.showLogin(from: self)
                        }
                    })
                } else {
                    print(error)
                }
            }
        }
    }
}

