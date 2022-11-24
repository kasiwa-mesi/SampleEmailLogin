//
//  AppDelegate.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/18.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.kasiwa")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    Router.shared.showRoot(window: UIWindow(frame: UIScreen.main.bounds))
                }
            } else {
                DispatchQueue.main.async {
                    Router.shared.showOffline(window: UIWindow(frame: UIScreen.main.bounds))
                }
            }
        }
        
        monitor.start(queue: queue)
        
        return true
    }
}

