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
    
    init() {
        self._imagePickerController = UIImagePickerController()
        
        guard let userId = AuthService.shared.getCurrentUserId() else {
            fatalError()
        }
        self._userId = userId
    }
    
    func uploadImage(data: Data) {
        StorageService.shared.uploadMemoImage(userId: self.userId, imageData: data) { isUploaded, imageRef in
            if isUploaded {
                StorageService.shared.downloadImage(imageRef: imageRef) { url in
                    self._imageURL = url
                }
            }
        }
    }
    
    func addMemo(text: String, vc: UIViewController) {
        var imageURL: String?
        
        if self.imageURL != nil {
            imageURL = self.imageURL?.absoluteString
        } else {
            imageURL = ""
        }
        
        guard let url = imageURL else {
            fatalError()
        }
        
        if let validationAlertMessage = Validator(email: nil, password: nil, reconfirmPassword: nil, memoText: text)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            vc.showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            DatabaseService.shared.addMemo(text: text, userId: self.userId, imageURL: url) { isCreated in
                if isCreated {
                    Router.shared.showReStart()
                }
            }
        }
    }
}
