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
        viewModel = SetEmailChangedViewModel()
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
