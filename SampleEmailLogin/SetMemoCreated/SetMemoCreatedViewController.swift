//
//  SetMemoCreatedViewController.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/03.
//

import UIKit
import UITextView_Placeholder
import FirebaseCore
import FirebaseFirestore

final class SetMemoCreatedViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    
    var imageURL: URL?
    @IBOutlet weak var memoImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton! {
        didSet {
            selectImageButton.addTarget(self, action: #selector(tapSelectButton), for: .touchUpInside)
        }
    }
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.addTarget(self, action: #selector(tapSubmitButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var memoFieldTextView: UITextView! {
        didSet {
            memoFieldTextView.placeholder = "メモを入力してください"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> SetMemoCreatedViewController {
        guard let vc = UIStoryboard.init(name: "SetMemoCreated", bundle: nil).instantiateInitialViewController() as? SetMemoCreatedViewController else {
            fatalError()
        }
        return vc
    }
    
}

private extension SetMemoCreatedViewController {
    @objc func tapSubmitButton() {
        print("メモ作成処理")
        guard let text = memoFieldTextView.text else {
            fatalError()
        }
        guard let userId = AuthController.shared.getCurrentUserId() else {
            fatalError()
        }
        
        guard let url = self.imageURL?.absoluteString else {
            fatalError()
        }
        
        if let validationAlertMessage = Validator(email: nil, password: nil, reconfirmPassword: nil, memoText: text)?.alertMessage {
            let gotItAction = UIAlertAction(title: "了解しました", style: .default)
            showAlert(title: validationAlertMessage, message: "", actions: [gotItAction])
        } else {
            CloudFirestoreService.shared.addMemo(text: text, userId: userId, imageURL: url) { isCreated in
                if isCreated {
                    Router.shared.showReStart()
                }
            }
        }
    }
}

extension SetMemoCreatedViewController: UIImagePickerControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            let mediaType = info[.mediaType] as? String
            print("画像を選択する")
            print(image)
            print(mediaType)
            imagePickerController.dismiss(animated: true)
            self.memoImageView.image = image
            
            guard let userId = AuthController.shared.getCurrentUserId() else {
                fatalError()
            }
        
            guard let data = self.memoImageView.image?.pngData() else {
                fatalError()
            }
                        
            FirebaseStorageService.shared.uploadMemoImage(userId: userId, imageData: data) { isUploaded, imageRef in
                if isUploaded {
                    FirebaseStorageService.shared.downloadImage(imageRef: imageRef) { url in
                        self.imageURL = url
                        print(self.imageURL)
                    }
                }
            }
//            self.imageURL = downloadURL
//            print("帰ってきたURLを確認")
//            print(self.imageURL)
        }
}

extension SetMemoCreatedViewController: UINavigationControllerDelegate {
    @objc func tapSelectButton() {
        print("端末のライブラリから画像を選ぶ")
        self.imagePickerController.mediaTypes = ["public.image"]
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.delegate = self
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
}
