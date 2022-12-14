//
//  SplashViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/12/14.
//

import UIKit

final class SplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> SplashViewController {
        guard let vc = UIStoryboard.init(name: "Splash", bundle: nil).instantiateInitialViewController() as? SplashViewController else {
            fatalError()
        }
        return vc
    }
}
