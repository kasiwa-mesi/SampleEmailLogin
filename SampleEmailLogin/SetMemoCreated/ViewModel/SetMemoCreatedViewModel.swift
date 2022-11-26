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
    private(set) var imageURL: URL?
    private(set) var imagePickerController: UIImagePickerController
    private(set) var userId: String
    
    init() {
        self.imagePickerController = UIImagePickerController()
        
        guard let userId = AuthService.shared.getCurrentUserId() else {
            fatalError()
        }
        self.userId = userId
    }
    
    func uploadImage(data: Data) {
        FirebaseStorageService.shared.uploadMemoImage(userId: self.userId, imageData: data) { isUploaded, imageRef in
            if isUploaded {
                FirebaseStorageService.shared.downloadImage(imageRef: imageRef) { url in
                    self.imageURL = url
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
            CloudFirestoreService.shared.addMemo(text: text, userId: self.userId, imageURL: url) { isCreated in
                if isCreated {
                    Router.shared.showReStart()
                }
            }
        }
    }
}
