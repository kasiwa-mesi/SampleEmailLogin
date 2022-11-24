//
//  RegisterViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/18.
//

import UIKit

final class RegisterViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var reconfirmPasswordTextField: UITextField!
    
    @IBOutlet private weak var moveLoginScreenButton: UIButton! {
        didSet {
            moveLoginScreenButton.addTarget(self, action: #selector(tapMoveLoginScreenButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var registerButton: UIButton! {
        didSet {
            registerButton.addTarget(self, action: #selector(tapRegisterButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var moveTrialButton: UIButton! {
            didSet {
                moveTrialButton.addTarget(self, action: #selector(tapTrial), for: .touchUpInside)
            }
    }
    
    private var viewModel: RegisterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegisterViewModel()
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
        
        viewModel.createUser(email: email, password: password, reconfirmPassword: reconfirmPassword, vc: self)
    }
    
    @objc func tapTrial() {
        Router.shared.showTrial(from: self)
    }
}

