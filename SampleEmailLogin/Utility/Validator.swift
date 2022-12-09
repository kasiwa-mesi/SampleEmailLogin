//
//  Validator.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/10/27.
//

import Foundation

enum Validator {
    case isEmptyEmail, isEmptyPassword, isEmptyReconfirmPassword, isEmptyMemoText, isUnavailableEmail, isUnavailablePassword, isUnavailableMemoText, isConfirmedPassword, isSameMemoText
    
    init?(email: String?, password: String?, reconfirmPassword: String?, memoText: String?, updatedMemoText: String?) {
        let checkEmailFormat = { (email: String) -> Bool? in
            let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
            guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
            let checkingResults = regex.matches(in: email, range: NSRange(location: 0, length: email.count))
            return checkingResults.count > 0
        }
        
        if let email {
            guard !email.isEmpty else {
                self = .isEmptyEmail
                return
            }
            if checkEmailFormat(email) == false {
                self = .isUnavailableEmail
                return
            }
        }
        
        if let password {
            guard !password.isEmpty else {
                self = .isEmptyPassword
                return
            }
            
            if password.count < 6 {
                self = .isUnavailablePassword
                return
            }
        }
        
        if let reconfirmPassword {
            guard !reconfirmPassword.isEmpty else {
                self = .isEmptyReconfirmPassword
                return
            }

            if password != reconfirmPassword {
                self = .isConfirmedPassword
                return
            }
        }
        
        if let memoText {
            guard !memoText.isEmpty else {
                self = .isEmptyMemoText
                return
            }
            
            if memoText.count > 512 {
                self = .isUnavailableMemoText
                return
            }
        }
        
        if let updatedMemoText {
            if updatedMemoText == memoText {
                self = .isSameMemoText
                return
            }
            
            guard !updatedMemoText.isEmpty else {
                self = .isEmptyMemoText
                return
            }
            
            if updatedMemoText.count > 512 {
                self = .isUnavailableMemoText
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
        case .isEmptyReconfirmPassword:
            return "確認用パスワードが入力されていません"
        case .isEmptyMemoText:
            return "メモが入力されていません"
        case .isSameMemoText:
            return "メモの内容が変更されていません"
        case .isUnavailableMemoText:
            return "メモの文字数は512文字数以下で入力してください"
        case .isUnavailableEmail:
            return "メールアドレスの形式で入力してください"
        case .isUnavailablePassword:
            return "パスワードは6文字以上で入力してください"
        case .isConfirmedPassword:
            return "パスワードと確認用パスワードが一致しません"
        }
    }
}
