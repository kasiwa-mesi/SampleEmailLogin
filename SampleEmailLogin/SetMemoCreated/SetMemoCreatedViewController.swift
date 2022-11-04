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
import FirebaseAuth

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
        let text = memoFieldTextView.text
        let userId = AuthController.shared.getCurrentUserId()
        let db = Firestore.firestore()
        if let validationAlertMessage = Validator(email: nil, password: nil, reconfirmPassword: nil, memoText: text)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            db.collection("memos").addDocument(data: [
                "text": text,
                //"imageURL": imageURL
                "userId": userId,
                "createdAt": FirebaseFirestore.FieldValue.serverTimestamp()
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("メモを無事保存できました！")
                    Router.shared.showReStart()
                }
            }
        }
    }
}
