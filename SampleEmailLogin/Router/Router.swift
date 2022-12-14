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
        AuthService.shared.isLogined { (hasAuthentication) in
            if hasAuthentication {
                let vc = HomeViewController.makeFromStoryboard()
                self.pushNavigate(vc: vc, window: window)
            } else {
                let vc = RegisterViewController.makeFromStoryboard()
                self.pushNavigate(vc: vc, window: window)
            }
        }
    }
    
    func showOffline(window: UIWindow?) {
        let vc = OfflineViewController.makeFromStoryboard()
        self.pushNavigate(vc: vc, window: window)
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
        let vc = SplashViewController.makeFromStoryboard()
        self.pushNavigate(vc: vc, window: window)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Int.splashDisplayedTime) {
            self.showRoot(window: self.window)
        }
    }
    
    func showSetMemoCreated(from: UIViewController) {
        let vc = SetMemoCreatedViewController.makeFromStoryboard()
        show(from: from, next: vc)
    }
    
    func showSetMemoChanged(from: UIViewController, memo: MemoModel) {
        let vc = SetMemoChangedViewController.makeFromStoryboard(memo: memo)
        show(from: from, next: vc)
    }
    
    func showTrial(from: UIViewController) {
        let vc = TrialViewController.makeFromStoryboard()
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
    
    func pushNavigate(vc: UIViewController, window: UIWindow?) {
        let navigationController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        self.window = window
    }
}
