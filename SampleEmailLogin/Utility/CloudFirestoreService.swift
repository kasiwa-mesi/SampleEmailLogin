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
        var memos: [MemoModel] = []
        db.collection("memos").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                return
            }
            
            memos = documents.compactMap { (queryDocumentSnapshot) -> MemoModel? in
                return try? queryDocumentSnapshot.data(as: MemoModel.self)
            }
            completion(memos)
        }
    }
    
    func addMemo(text: String, userId: String, imageURL: String, completion: @escaping (Bool) -> Void) {
        db.collection("memos").addDocument(data: [
            "text": text,
            "userId": userId,
            "createdAt": FirebaseFirestore.FieldValue.serverTimestamp(),
            // 画像アップロード機能を実装したら、引数にimageURLを渡す
            "imageURL": imageURL
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                completion(false)
            } else {
                completion(true)
            }
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
