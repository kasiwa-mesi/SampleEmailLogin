//
//  Validator.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/27.
//

import Foundation

enum Validator {
    case isEmptyEmail, isEmptyPassword, isUnavailableEmail, isUnavailablePassword
    
    init?(email: String?, password: String?) {
        let checkEmailFormat = { (email: String) -> Bool? in
            let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
            guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
            let checkingResults = regex.matches(in: email, range: NSRange(location: 0, length: email.count))
            return checkingResults.count > 0
        }
        
        if email != nil {
            guard let email = email, !email.isEmpty else {
                self = .isEmptyEmail
                return
            }
            if checkEmailFormat(email) == false {
                self = .isUnavailableEmail
                return
            }
        }
        
        if password != nil {
            guard let password = password, !password.isEmpty else {
                self = .isEmptyPassword
                return
            }
            
            if password.count < 6 {
                self = .isUnavailablePassword
                return
            }
        }
        
        return nil
        
    }
    
    var alertMessage: String {
        switch self {
        case .isEmptyEmail:
            return "メールアドレスが入力されていません"
        case .isEmptyPassword:
            return "パスワードが入力されていません"
        case .isUnavailableEmail:
            return "メールアドレスの形式で入力してください"
        case .isUnavailablePassword:
            return "パスワードは6文字以上で入力してください"
        }
    }
}
