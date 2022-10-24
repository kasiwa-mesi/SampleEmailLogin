//
//  AuthController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/20.
//

import Foundation
import FirebaseAuth

final class AuthController {
    static let shared: AuthController = .init()
    private init() {}
    
    func isLogined(completionHandler: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener({ auth, user in
            if user == nil {
               completionHandler(false)
            } else {
               completionHandler(true)
            }
        })
    }
}

