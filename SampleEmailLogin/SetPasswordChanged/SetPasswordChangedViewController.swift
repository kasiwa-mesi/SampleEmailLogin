//
//  SetPasswordChangedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/25.
//

import UIKit

final class SetPasswordChangedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> SetPasswordChangedViewController {
        guard let vc = UIStoryboard.init(name: "SetPasswordChanged", bundle: nil).instantiateInitialViewController() as? SetPasswordChangedViewController else {
            fatalError()
        }
        return vc
    }
}
