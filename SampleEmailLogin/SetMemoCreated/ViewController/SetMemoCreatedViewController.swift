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
    private var viewModel: SetMemoCreatedViewModel!
    
    @IBOutlet private weak var memoImageView: UIImageView!
    @IBOutlet private weak var selectImageButton: UIButton! {
        didSet {
            selectImageButton.addTarget(self, action: #selector(tapSelectButton), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            submitButton.addTarget(self, action: #selector(tapSubmitButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var memoFieldTextView: UITextView! {
        didSet {
            memoFieldTextView.placeholder = String.memoPlaceholder
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    func setupViewModel() {
        viewModel = SetMemoCreatedViewModel(input: self)
    }
    
    static func makeFromStoryboard() -> SetMemoCreatedViewController {
        guard let vc = UIStoryboard.init(name: "SetMemoCreated", bundle: nil).instantiateInitialViewController() as? SetMemoCreatedViewController else {
            fatalError()
        }
        return vc
    }
    
}

extension SetMemoCreatedViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        viewModel.imagePickerController.dismiss(animated: true)
        self.memoImageView.image = image
        
        guard let data = self.memoImageView.image?.pngData() else {
            fatalError()
        }
        
        viewModel.uploadImage(data: data)
    }
}

@objc extension SetMemoCreatedViewController: UINavigationControllerDelegate {
    private func tapSelectButton() {
        viewModel.imagePickerController.mediaTypes = ["public.image"]
        viewModel.imagePickerController.sourceType = .photoLibrary
        viewModel.imagePickerController.delegate = self
        self.present(viewModel.imagePickerController, animated: true, completion: nil)
    }
    
    private func tapSubmitButton() {
        guard let text = memoFieldTextView.text else {
            fatalError()
        }
        viewModel.addMemo(text: text)
    }
}

extension SetMemoCreatedViewController: SetMemoCreatedViewModelInput {
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
    
    func show(validationMessage: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        self.showAlert(title: validationMessage, message: "", actions: [gotItAction])
    }
}
