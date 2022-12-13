//
//  SetEmailChangedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/25.
//

import UIKit

final class SetEmailChangedViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailChangeButton: UIButton! {
        didSet {
            emailChangeButton.addTarget(self, action: #selector(tapEmailChangeButton), for: .touchUpInside)
        }
    }
    
    private var viewModel: SetEmailChangedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    func setupViewModel() {
        viewModel = SetEmailChangedViewModel(input: self)
        viewModel.isLogined()
    }
    
    static func makeFromStoryboard() -> SetEmailChangedViewController {
        guard let vc = UIStoryboard.init(name: "SetEmailChanged", bundle: nil).instantiateInitialViewController() as? SetEmailChangedViewController else {
            fatalError()
        }
        return vc
    }
}

@objc private extension SetEmailChangedViewController {
    func tapEmailChangeButton() {
        let newEmail = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        viewModel.updateEmail(newEmail: newEmail, password: password)
    }
}

extension SetEmailChangedViewController: SetEmailChangedViewModelInput {
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
    
    func show(validationMessage: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        self.showAlert(title: validationMessage, message: "", actions: [gotItAction])
    }
    
    func showLoginAlert() {
        let moveLoginAction = UIAlertAction(title: String.loginActionButtonLabel, style: .default) { _ in
            self.viewModel.logOut()
        }
        self.showAlert(title: String.loginAlertTitle, message: "", actions: [moveLoginAction])
    }
}
