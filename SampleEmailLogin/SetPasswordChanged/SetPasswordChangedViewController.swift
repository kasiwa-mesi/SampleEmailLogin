//
//  SetPasswordChangedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/25.
//

import UIKit
import FirebaseAuth

final class SetPasswordChangedViewController: UIViewController {
    
    @IBOutlet weak var userEmailLabel: UILabel!
        
    @IBOutlet weak var setPasswordChangedButton: UIButton! {
        didSet {
            setPasswordChangedButton.addTarget(self, action: #selector(tapPasswordChangeButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let email = Auth.auth().currentUser?.email {
            userEmailLabel.text = "\(email)宛にパスワード再設定用のリンクを送信致しました"
        }
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
        
        print(email)
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                Router.shared.showReStart()
            } else {
                print("パスワード再設定できません")
            }
        }
    }
}
