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
}

final class HomeViewModel: HomeViewModelOutput, HasDisposeBag {
    
    private let _loading: PublishRelay<Bool> = .init()
    lazy var loadingObservable: Observable<Bool> = _loading.asObservable()
    private let _selectMemoModel: PublishRelay<MemoModel> = .init()
    lazy var selectMemoModelObservable: Observable<MemoModel> = _selectMemoModel.asObservable()
    
    //最後に取得したデータ
    private(set) var memos: [MemoModel] = []
    
    init(input: HomeViewModelInput) {
        input.didSelectObservable
            .filter { $0 < self.memos.count - 1 }
            .map { self.memos[$0] }
            .bind(to: _selectMemoModel).disposed(by: disposeBag)
    }
    
    
    //自分のメモを全て取得する
    func fetchMemos(completion: @escaping (Bool) -> Void) {
        guard let userId = FirebaseAuthService.shared.getCurrentUserId() else {
            fatalError()
        }
        
        CloudFirestoreService.shared.getCollection(userId: userId) { (memos) in
            if memos.isEmpty {
                completion(false)
            } else {
                self.memos = memos
                self._loading.accept(false)
                completion(true)
            }
        }
    }
}
