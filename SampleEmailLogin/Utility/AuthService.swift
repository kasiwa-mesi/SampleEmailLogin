//
//  AuthService.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/26.
//

import Foundation
import FirebaseAuth

final class AuthService {
    static let shared: AuthService = .init()
    private init() {}
    
    func getCurrentUser() -> User? { Auth.auth().currentUser }
    
    func getCurrentUserId() -> String? { Auth.auth().currentUser?.uid }
    
    func getIsEmailVerified() -> Bool? {
        Auth.auth().currentUser?.isEmailVerified
    }
    
    func getCredential(email: String, password: String) -> AuthCredential {
        EmailAuthProvider.credential(withEmail: email, password: password)
    }
    
    func setLanguageCode(code: String) {
        Auth.auth().languageCode = code
    }
    
    
    func isLogined(completionHandler: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener({ auth, user in
            if user == nil {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        })
    }
    
    func createUser(email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if authResult != nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func sendEmailVerification() {
        let user = getCurrentUser()
        user?.sendEmailVerification()
    }
    
    func sendPasswordReset(email: String, completionHandler: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    func updateEmail(email: String, completionHandler: @escaping (Bool) -> Void) {
        let user = getCurrentUser()
        user?.updateEmail(to: email) { error in
            if error == nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    func reAuthenticate(credential: AuthCredential, completionHandler: @escaping (Bool) -> Void) {
        let user = Auth.auth().currentUser
        user?.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                print(error)
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
}
