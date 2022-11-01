//
//  SetEmailChangedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/25.
//

import UIKit
import FirebaseAuth

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
        guard let email = Auth.auth().currentUser?.email else {
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
        if let validationAlertMessage = Validator.init(email: newEmail, password: nil, reconfirmPassword: nil)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            // 再認証処理を走らせる
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            
            AuthController.shared.reAuthenticate(credential: credential) { (hasAuthentication) in
                if hasAuthentication {
                    print(hasAuthentication)
                    print(Auth.auth().currentUser)
                    Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
                        if error == nil {
                            Router.shared.showReStart()
                        } else {
                            print("メールアドレス更新できません")
                            print(error)
                        }
                    }
                } else {
                    print("もう一度ログインしてください")
                    // UIAlertControllerで「もう一度ログインしてください。」と表示
                }
            }
        }
    }
}
