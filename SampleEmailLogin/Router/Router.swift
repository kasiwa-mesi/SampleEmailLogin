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
        AuthController.shared.isLogined { (hasAuthentication) in
            if hasAuthentication {
                //ログインしている場合、Home画面へ飛ばす
                print("HOMEへ")
                let vc = HomeViewController.makeFromStoryboard()
                let nav = UINavigationController(rootViewController: vc)
                window?.rootViewController = nav
                window?.makeKeyAndVisible()
            } else {
                // ログインしていない場合、Register画面へ飛ばす
                print("Registerへ")
                let vc = RegisterViewController.makeFromStoryboard()
                let nav = UINavigationController(rootViewController: vc)
                window?.rootViewController = nav
                window?.makeKeyAndVisible()
            }
        }
        // ログインしているか否かで遷移先を変える
    }
}
