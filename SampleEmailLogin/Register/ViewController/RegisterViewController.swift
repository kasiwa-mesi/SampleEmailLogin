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
        viewModel = RegisterViewModel(input: self)
    }
    
    static func makeFromStoryboard() -> RegisterViewController {
        guard let vc = UIStoryboard.init(name: "Register", bundle: nil).instantiateInitialViewController() as? RegisterViewController else {
            fatalError()
        }
        return vc
    }
}

@objc private extension RegisterViewController {
    func tapMoveLoginScreenButton() {
        Router.shared.showLogin(from: self)
    }
    
    func tapRegisterButton() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let reconfirmPassword = reconfirmPasswordTextField.text ?? ""
        
        viewModel.createUser(email: email, password: password, reconfirmPassword: reconfirmPassword)
    }
    
    func tapTrial() {
        Router.shared.showTrial(from: self)
    }
}

extension RegisterViewController: RegisterViewModelInput {
    func show(validationMessage: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        self.showAlert(title: validationMessage, message: "", actions: [gotItAction])
    }
    
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
}
