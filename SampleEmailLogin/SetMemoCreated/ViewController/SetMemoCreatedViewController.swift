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
import RxSwift

final class SetMemoCreatedViewController: UIViewController {
    private var viewModel: SetMemoCreatedViewModel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.isHidden = true
        }
    }
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
        viewModel.isLogined()
        
        viewModel.loadingObservable
            .bind(to: Binder(self) { vc, loading in
                vc.selectImageButton.isHidden = loading
                vc.indicator.isHidden = !loading
            }).disposed(by: rx.disposeBag)
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
        let image = info[.originalImage] as? UIImage
        
        viewModel.imagePickerController.dismiss(animated: true)
        self.memoImageView.image = image
        
        guard let data = self.memoImageView.image?.pngData() else {
            showImageErrorAlert()
            return
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
        let text = memoFieldTextView.text ?? ""
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
    
    func showLoginAlert() {
        let moveLoginAction = UIAlertAction(title: String.loginActionButtonLabel, style: .default) { _ in
            self.viewModel.logOut()
        }
        self.showAlert(title: String.loginAlertTitle, message: "", actions: [moveLoginAction])
    }
    
    func showImageErrorAlert() {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.imageErrorTitle
        self.showAlert(title: errorTitle, message: "", actions: [gotItAction])
    }
}
