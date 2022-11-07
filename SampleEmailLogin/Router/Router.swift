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
    
    private var window: UIWindow?

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
            self.window = window
        }
        // ログインしているか否かで遷移先を変える
    }
    
    func showLogin(from: UIViewController) {
        let vc = LoginViewController.makeFromStoryboard()
        show(from: from, next: vc)
    }
    
    func showHome(from: UIViewController) {
        let vc = HomeViewController.makeFromStoryboard()
        show(from: from, next: vc)
    }
    
    func showSetEmailChanged(from: UIViewController) {
        let vc = SetEmailChangedViewController.makeFromStoryboard()
        show(from: from, next: vc)
    }
    
    func showSetPasswordChanged(from: UIViewController) {
        let vc = SetPasswordChangedViewController.makeFromStoryboard()
        show(from: from, next: vc)
    }
    
    func showReStart() {
        print("再構築")
        showRoot(window: window)
    }
    
    func showSetMemoCreated(from: UIViewController) {
        let vc = SetMemoCreatedViewController.makeFromStoryboard()
        show(from: from, next: vc)
    }
    
    func showSetMemoChanged(from: UIViewController, memo: MemoModel) {
        let vc = SetMemoChangedViewController.makeFromStoryboard(memo: memo)
        show(from: from, next: vc)
    }
}

private extension Router {
    func show(from: UIViewController, next: UIViewController, animated: Bool = true) {
        if let nav = from.navigationController {
            nav.pushViewController(next, animated: animated)
        } else {
            from.present(next, animated: animated, completion: nil)
        }
    }
}
