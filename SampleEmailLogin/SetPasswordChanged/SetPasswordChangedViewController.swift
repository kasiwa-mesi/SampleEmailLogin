//
//  SetPasswordChangedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/25.
//

import UIKit
import FirebaseAuth

final class SetPasswordChangedViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var setPasswordChangedButton: UIButton! {
        didSet {
            setPasswordChangedButton.addTarget(self, action: #selector(tapPasswordChangeButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> SetPasswordChangedViewController {
        guard let vc = UIStoryboard.init(name: "SetPasswordChanged", bundle: nil).instantiateInitialViewController() as? SetPasswordChangedViewController else {
            fatalError()
        }
        return vc
    }
}

private extension SetPasswordChangedViewController {
    @objc func tapPasswordChangeButton() {
        print("Passwordを変更する")
        guard let email = Auth.auth().currentUser?.email else {
            fatalError()
        }
        
        guard let password = passwordTextField.text else {
            fatalError()
        }
        
        print(email)
        print(password)
        
        // 再認証処理を走らせる
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        AuthController.shared.reAuthenticate(credential: credential) { (hasAuthentication) in
            if hasAuthentication {
                print(hasAuthentication)
                print(Auth.auth().currentUser)
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if error == nil {
                        Router.shared.showReStart()
                    } else {
                        print("パスワード再設定できません")
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
