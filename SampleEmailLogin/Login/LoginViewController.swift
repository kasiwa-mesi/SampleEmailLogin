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
}

private extension LoginViewController {
    @objc func tapLoginButton() {
        //ログイン処理を行う
        print("ログイン")
    }
}
