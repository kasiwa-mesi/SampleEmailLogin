//
//  RegisterViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/18.
//

import UIKit

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
    }
}

