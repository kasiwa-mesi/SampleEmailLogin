//
//  CloudFirestoreService.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/06.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CloudFirestoreService {
    static let shared: CloudFirestoreService = .init()
    private init() {}
    
    private var db = Firestore.firestore()
    
    func getCollection(userId: String?, completion: @escaping ([MemoModel]) -> Void) {
        print("自分のメモを取得する")
        var memos: [MemoModel] = []
        db.collection("memos").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("documentsが存在しません")
                return
            }
            
            memos = documents.compactMap { (queryDocumentSnapshot) -> MemoModel? in
                return try? queryDocumentSnapshot.data(as: MemoModel.self)
            }
            completion(memos)
        }
    }
    
    func updateMemo(memo: MemoModel, completion: @escaping (Bool) -> Void) {
        guard let id = memo.id else {
            fatalError()
        }
        db.collection("memos").document(id).updateData([
            "text": memo.text,
            "imageURL": memo.imageURLStr
        ]) { (error) in
            if let error = error {
                print("アップデートする際にエラー発生")
                completion(false)
            } else {
                print("無事アップデートできました")
                completion(true)
            }
        }
    }
    
    func deleteMemo(memo: MemoModel, completion: @escaping (Bool) -> Void) {
        guard let id = memo.id else {
            fatalError()
        }
        db.collection("memos").document(id).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
                completion(false)
            } else {
                print("Document successfully removed!")
                completion(true)
            }
        }
    }
}
