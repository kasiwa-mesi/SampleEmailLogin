//
//  SetMemoChangedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/07.
//

import UIKit

final class SetMemoChangedViewController: UIViewController {
    
    @IBOutlet weak var memoFieldTextView: UITextView! {
        didSet {
            memoFieldTextView.placeholder = "メモを入力してください"
            memoFieldTextView.text = memo.text
        }
    }
    
    @IBOutlet weak var setMemoChangedButton: UIButton! {
        didSet {
            setMemoChangedButton.addTarget(self, action: #selector(tapSetMemoChangedButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard(memo: MemoModel) -> SetMemoChangedViewController {
        guard let vc = UIStoryboard.init(name: "SetMemoChanged", bundle: nil).instantiateInitialViewController() as? SetMemoChangedViewController else {
            fatalError()
        }
        print(memo)
        vc.memo = memo
        return vc
    }
    
    private var memo = MemoModel(id: nil, text: "", userId: "", createdAt: Date(), imageURLStr: "")
}

private extension SetMemoChangedViewController {
    @objc func tapSetMemoChangedButton() {
        let memo = MemoModel(id: memo.id, text: memoFieldTextView.text, userId: memo.userId, createdAt: memo.createdAt, imageURLStr: memo.imageURLStr)
        
        if let validationAlertMessage = Validator(email: nil, password: nil, reconfirmPassword: nil, memoText: memo.text)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            print("更新するメモ: \(memo)")
            if self.memo.text != memo.text {
                CloudFirestoreService.shared.updateMemo(memo: memo) { (isUpdated) in
                    if isUpdated {
                        Router.shared.showReStart()
                    }
                }
            } else {
                print("変更点がないため、更新処理を走らせない")
                Router.shared.showReStart()
            }
        }
    }
}
