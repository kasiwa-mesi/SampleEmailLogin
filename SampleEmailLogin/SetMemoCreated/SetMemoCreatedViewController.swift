//
//  SetMemoCreatedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/03.
//

import UIKit
import UITextView_Placeholder
import FirebaseCore
import FirebaseFirestore

final class SetMemoCreatedViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.addTarget(self, action: #selector(tapSubmitButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var memoFieldTextView: UITextView! {
        didSet {
            memoFieldTextView.placeholder = "メモを入力してください"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> SetMemoCreatedViewController {
        guard let vc = UIStoryboard.init(name: "SetMemoCreated", bundle: nil).instantiateInitialViewController() as? SetMemoCreatedViewController else {
            fatalError()
        }
        return vc
    }
    
}

private extension SetMemoCreatedViewController {
    @objc func tapSubmitButton() {
        print("メモ作成処理")
        guard let text = memoFieldTextView.text else {
            fatalError()
        }
        guard let userId = AuthController.shared.getCurrentUserId() else {
            fatalError()
        }
        let db = Firestore.firestore()
        if let validationAlertMessage = Validator(email: nil, password: nil, reconfirmPassword: nil, memoText: text)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            CloudFirestoreService.shared.addMemo(text: text, userId: userId, imageURL: "") { isCreated in
                if isCreated {
                    Router.shared.showReStart()
                }
            }
        }
    }
}
