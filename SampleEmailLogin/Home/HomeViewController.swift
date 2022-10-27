//
//  HomeViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/19.
//

import UIKit
import FirebaseAuth

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton! {
        didSet {
            signOutButton.addTarget(self, action: #selector(tapSignOutButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var moveSetEmailChangedButton: UIButton! {
        didSet {
            moveSetEmailChangedButton.addTarget(self, action: #selector(tapMoveSetEmailChanged), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var moveSetPasswordChangedButton: UIButton! {
        didSet {
            moveSetPasswordChangedButton.addTarget(self, action: #selector(tapMoveSetPasswordChanged), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> HomeViewController {
        guard let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController() as? HomeViewController else {
            fatalError()
        }
        return vc
    }
}

private extension HomeViewController {
    @objc func tapSignOutButton() {
        print("ログアウト")
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @objc func tapMoveSetEmailChanged() {
        print("メールアドレス変更へ遷移")
        Router.shared.showSetEmailChanged(from: self)
    }
    
    @objc func tapMoveSetPasswordChanged() {
        print("パスワード再設定へ移動")
        Router.shared.showSetPasswordChanged(from: self)
    }
}
