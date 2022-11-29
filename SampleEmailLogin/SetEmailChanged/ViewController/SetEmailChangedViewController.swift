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
        guard let newEmail = emailTextField.text else {
            fatalError()
        }
        
        guard let password = passwordTextField.text else {
            fatalError()
        }
        
        viewModel.updateEmail(newEmail: newEmail, password: password, vc: self)
    }
}

extension SetEmailChangedViewController: SetEmailChangedViewModelInput {
    func show(validationMessage: String) {
        let gotItAction = UIAlertAction(title: "了解しました", style: .default)
        self.showAlert(title: validationMessage, message: "", actions: [gotItAction])
    }
    
    func showLoginAlert() {
        let moveLoginAction = UIAlertAction(title: "ログイン画面に移動", style: .default) { _ in
            Router.shared.showLogin(from: self)
        }
        self.showAlert(title: "直近でログインしていないため、もう一度行ってください", message: "", actions: [moveLoginAction])
    }
}
