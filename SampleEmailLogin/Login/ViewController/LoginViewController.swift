//
//  LoginViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/18.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            loginButton.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        }
    }
    
    private var viewModel: LoginViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
    }
    
    static func makeFromStoryboard() -> LoginViewController {
        guard let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() as? LoginViewController else {
            fatalError()
        }
        return vc
    }
}

@objc private extension LoginViewController {
    func tapLoginButton() {
        guard let email = emailTextField.text else {
            fatalError()
        }
        
        guard let password = passwordTextField.text else {
            fatalError()
        }
        
        viewModel.signIn(email: email, password: password, vc: self)
    }
}
