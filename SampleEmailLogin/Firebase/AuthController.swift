//
//  AuthController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/19.
//

import Foundation
import FirebaseAuth

final class AuthController {
    static let shared: AuthController = .init()
    private init() {}
    
    func isLogined(completionHandler: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener({ auth, user in
            print("userの値確認")
            print(user)
            print("Authの値確認")
            print(auth)
            if user == nil {
               completionHandler(false)
            } else {
               completionHandler(true)
            }
        })
    }
}
