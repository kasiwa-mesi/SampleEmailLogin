//
//  HomeViewModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/19.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

protocol HomeViewModelInput {
    var didSelectObservable: Observable<Int> { get }
    func show()
}

protocol HomeViewModelOutput {
    var loadingObservable: Observable<Bool> { get }
    var selectMemoModelObservable: Observable<MemoModel> { get }
    var showEmptyViewObservable: Observable<Bool> { get }
    var updateMemoModelsObservable: Observable<[MemoModel]> { get }
    var memos: [MemoModel] { get }
    var userId: String { get }
    var email: String { get }
}

final class HomeViewModel: HomeViewModelOutput, HasDisposeBag {
    
    private let _loading: PublishRelay<Bool> = .init()
    lazy var loadingObservable: Observable<Bool> = _loading.asObservable()
    private let _selectMemoModel: PublishRelay<MemoModel> = .init()
    lazy var selectMemoModelObservable: Observable<MemoModel> = _selectMemoModel.asObservable()
    private let _showEmptyView: PublishRelay<Bool> = .init()
    lazy var showEmptyViewObservable: Observable<Bool> = _showEmptyView.asObservable()
    private let _updateMemoModels: PublishRelay<[MemoModel]> = .init()
    lazy var updateMemoModelsObservable: Observable<[MemoModel]> = _updateMemoModels.asObservable()
    
    private var _memos: [MemoModel] = []
    var memos: [MemoModel] {
        get {
            return _memos
        }
    }
    
    private var _userId: String
    var userId: String {
        get {
            return _userId
        }
    }
    
    private var _email: String
    var email: String {
        get {
            return _email
        }
    }
    
    private var input: HomeViewModelInput!
    init(input: HomeViewModelInput) {
        guard let userId = AuthService.shared.getCurrentUserId() else {
            fatalError()
        }
        
        guard let email = AuthService.shared.getCurrentUser()?.email else {
            fatalError()
        }
        
        self._email = email
        self._userId = userId
        self.input = input
        
        input.didSelectObservable
            .filter { $0 < self.memos.count }
            .map { self.memos[$0] }
            .bind(to: _selectMemoModel).disposed(by: disposeBag)
    }
    
    func fetchMemos() {
        DatabaseService.shared.getCollection(userId: self.userId) { (memos) in
            if !memos.isEmpty {
                self._memos = memos
                self._loading.accept(false)
                self._updateMemoModels.accept(memos)
            } else {
                self._showEmptyView.accept(!memos.isEmpty)
            }
        }
    }
    
    func getIsEmailVerified() {
        if AuthService.shared.getIsEmailVerified() == false {
            self.input.show()
        }
    }
    
    func sendEmailVerification() {
        AuthService.shared.setLanguageCode(code: String.languageCode)
        AuthService.shared.sendEmailVerification()
    }
    
    func logOut() {
        AuthService.shared.signOut()
    }
}
