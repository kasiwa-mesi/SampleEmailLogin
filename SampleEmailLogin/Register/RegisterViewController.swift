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
        
        if let validationAlertMessage = Validator(email: emailTextField.text, password: passwordTextField.text)?.alertMessage {
            let alertViewController = UIAlertController(title: validationAlertMessage, message: "", preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "了解しました", style: .default))
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let user = authResult?.user {
                    print(user)
                } else {
                    print(error)
                }
            }
        }
    }
}

