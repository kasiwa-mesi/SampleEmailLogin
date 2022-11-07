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
        print("メモを更新する")
    }
}
