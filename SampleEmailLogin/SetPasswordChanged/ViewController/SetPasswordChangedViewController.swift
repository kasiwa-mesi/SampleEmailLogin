//
//  SetPasswordChangedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/25.
//

import UIKit

final class SetPasswordChangedViewController: UIViewController {
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var setPasswordChangedButton: UIButton! {
        didSet {
            setPasswordChangedButton.addTarget(self, action: #selector(tapPasswordChangeButton), for: .touchUpInside)
        }
    }
    
    private var viewModel: SetPasswordChangedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SetPasswordChangedViewModel(input: self)
        userEmailLabel.text = "\(viewModel.email)宛にパスワード再設定用のリンクを送信します"
    }
    
    static func makeFromStoryboard() -> SetPasswordChangedViewController {
        guard let vc = UIStoryboard.init(name: "SetPasswordChanged", bundle: nil).instantiateInitialViewController() as? SetPasswordChangedViewController else {
            fatalError()
        }
        return vc
    }
}

@objc private extension SetPasswordChangedViewController {
    func tapPasswordChangeButton() {
        viewModel.passwordReset()
    }
}

extension SetPasswordChangedViewController: SetPasswordChangedViewModelInput {
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
}
