//
//  Router.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/19.
//

import UIKit

final class Router {
    static let shared: Router = .init()
    private init() {}

    func showRoot(window: UIWindow?) {
        let vc = RegisterViewController.makeFromStoryboard()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
