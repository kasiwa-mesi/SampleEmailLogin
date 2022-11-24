//
//  TrialViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/24.
//

import UIKit

final class TrialViewController: UIViewController {
    @IBOutlet private weak var memoFieldTextView: UITextView! {
        didSet {
            memoFieldTextView.placeholder = "メモを入力してください"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> TrialViewController {
        guard let vc = UIStoryboard.init(name: "Trial", bundle: nil).instantiateInitialViewController() as? TrialViewController else {
            fatalError()
        }
        return vc
    }
}
