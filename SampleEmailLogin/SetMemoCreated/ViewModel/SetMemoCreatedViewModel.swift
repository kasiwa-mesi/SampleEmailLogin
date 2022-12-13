//
//  SetMemoCreatedViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/22.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

protocol SetMemoCreatedViewModelInput {
    func show(validationMessage: String)
    func showLoginAlert()
    func showErrorAlert(code: String, message: String)
}

protocol SetMemoCreatedViewModelOutput {
    var userId: String { get }
    var imageURL: URL? { get }
    var imagePickerController: UIImagePickerController { get }
}

final class SetMemoCreatedViewModel: SetMemoCreatedViewModelOutput {
    private var _imageURL: URL?
    var imageURL: URL? {
        get {
            return _imageURL
        }
    }
    
    private var _imagePickerController: UIImagePickerController
    var imagePickerController: UIImagePickerController {
        get {
            return _imagePickerController
        }
    }
    
    private var _userId: String
    var userId: String {
        get {
            return _userId
        }
    }
    
    private var input: SetMemoCreatedViewModelInput!
    init(input: SetMemoCreatedViewModelInput) {
        self._imagePickerController = UIImagePickerController()
        
        let userId = AuthService.shared.getCurrentUserId()
        self._userId = userId ?? ""
        
        self.input = input
    }
    
    func uploadImage(data: Data) {
        StorageService.shared.uploadMemoImage(userId: self.userId, imageData: data) { error, imageRef in
            if let error {
                self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
                return
            }
            StorageService.shared.downloadImage(imageRef: imageRef) { error, url in
                if let error {
                    self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
                    return
                }
                self._imageURL = url
            }
        }
    }
    
    func addMemo(text: String) {
        let imageURL = self.imageURL?.absoluteString ?? ""

        if let validationAlertMessage = Validator(email: nil, password: nil, reconfirmPassword: nil, memoText: text, updatedMemoText: nil)?.alertMessage {
            input.show(validationMessage: validationAlertMessage)
        }
        
        DatabaseService.shared.addMemo(text: text, userId: self.userId, imageURL: imageURL) { error in
            if let error {
                self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
                return
            }
            Router.shared.showReStart()
        }
    }
    
    func isLogined() {
        if userId.isEmpty {
            self.input.showLoginAlert()
        }
    }
    
    func logOut() {
        AuthService.shared.signOut { error in
            self.showErrorAlert(error: error)
        }
    }
    
    private func showErrorAlert(error: NSError?) {
        if let error {
            self.input.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
}
