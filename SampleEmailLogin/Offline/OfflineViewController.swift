//
//  OfflineViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/24.
//

import UIKit

final class OfflineViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> OfflineViewController {
        guard let vc = UIStoryboard.init(name: "Offline", bundle: nil).instantiateInitialViewController() as? OfflineViewController else {
            fatalError()
        }
        return vc
    }
}
