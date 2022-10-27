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
    
    func reAuthenticate(credential: AuthCredential, completionHandler: @escaping (Bool) -> Void) {
        let user = Auth.auth().currentUser
        user?.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                print(error)
                completionHandler(false)
            } else {
                print("再認証成功")
                completionHandler(true)
            }
        }
    }
}

