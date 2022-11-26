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
}

protocol HomeViewModelOutput {
    var loadingObservable: Observable<Bool> { get }
    var selectMemoModelObservable: Observable<MemoModel> { get }
    var memos: [MemoModel] { get }
    var userId: String { get }
    var email: String { get }
}

final class HomeViewModel: HomeViewModelOutput, HasDisposeBag {
    
    private let _loading: PublishRelay<Bool> = .init()
    lazy var loadingObservable: Observable<Bool> = _loading.asObservable()
    private let _selectMemoModel: PublishRelay<MemoModel> = .init()
    lazy var selectMemoModelObservable: Observable<MemoModel> = _selectMemoModel.asObservable()
    
    //最後に取得したデータ
    private(set) var memos: [MemoModel] = []
    private(set) var userId: String
    private(set) var email: String
    
    init(input: HomeViewModelInput) {
        guard let userId = AuthService.shared.getCurrentUserId() else {
            fatalError()
        }
        
        guard let email = AuthService.shared.getCurrentUser()?.email else {
            fatalError()
        }
        
        self.userId = userId
        self.email = email

        input.didSelectObservable
            .filter { $0 < self.memos.count }
            .map { self.memos[$0] }
            .bind(to: _selectMemoModel).disposed(by: disposeBag)
    }
    
    //自分のメモを全て取得する
    func fetchMemos(completion: @escaping (Bool) -> Void) {
        DatabaseService.shared.getCollection(userId: self.userId) { (memos) in
            if memos.isEmpty {
                completion(false)
            } else {
                self.memos = memos
                self._loading.accept(false)
                completion(true)
            }
        }
    }
    
    func isEmailVerified() -> Bool {
        guard let isEmailVerified = AuthService.shared.getIsEmailVerified() else {
            fatalError()
        }
        return isEmailVerified
    }
    
    func sendEmailVerification() {
        AuthService.shared.setLanguageCode(code: "ja_JP")
        AuthService.shared.sendEmailVerification()
    }
    
    func logOut() {
        AuthService.shared.signOut()
    }
}
