//
//  SetMemoChangedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/07.
//

import UIKit
import Kingfisher

final class SetMemoChangedViewController: UIViewController {
    private var deleteButtonItem: UIBarButtonItem!
    
    @IBOutlet private weak var memoImageView: UIImageView! {
        didSet {
            let url = URL(string: viewModel.memo.imageURLStr)
            memoImageView.kf.setImage(with: url)
        }
    }
    
    @IBOutlet private weak var memoFieldTextView: UITextView! {
        didSet {
            memoFieldTextView.placeholder = "メモを入力してください"
            memoFieldTextView.text = viewModel.memo.text
        }
    }
    
    @IBOutlet private weak var setMemoChangedButton: UIButton! {
        didSet {
            setMemoChangedButton.addTarget(self, action: #selector(tapSetMemoChangedButton), for: .touchUpInside)
        }
    }
    
    private var viewModel: SetMemoChangedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(tapDeleteButton))
        self.navigationItem.rightBarButtonItem = deleteButtonItem
    }
    
    static func makeFromStoryboard(memo: MemoModel) -> SetMemoChangedViewController {
        guard let vc = UIStoryboard.init(name: "SetMemoChanged", bundle: nil).instantiateInitialViewController() as? SetMemoChangedViewController else {
            fatalError()
        }
        vc.setupViewModel(memo: memo)
        return vc
    }
}

private extension SetMemoChangedViewController {
    func setupViewModel(memo: MemoModel) {
        viewModel = SetMemoChangedViewModel(memo: memo)
    }
}

@objc private extension SetMemoChangedViewController {
    func tapSetMemoChangedButton() {
        let memo = MemoModel(id: viewModel.memo.id, text: memoFieldTextView.text, userId: viewModel.memo.userId, createdAt: viewModel.memo.createdAt, imageURLStr: viewModel.memo.imageURLStr)
        viewModel.updateMemo(memo: memo, vc: self)
    }
    
    func tapDeleteButton() {
        viewModel.deleteMemo(memo: viewModel.memo)
    }
}
