//
//  AppDelegate.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Register画面を構築")
        let window = UIWindow()
        
        Router.shared.showRoot(window: window)
        self.window = window
        
        return true
    }
}

