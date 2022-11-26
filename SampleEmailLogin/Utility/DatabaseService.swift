//
//  DatabaseService.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DatabaseService {
    static let shared: DatabaseService = .init()
    private init() {}
    
    private var db = Firestore.firestore()
    
    func getCollection(userId: String?, completion: @escaping ([MemoModel]) -> Void) {
        var memos: [MemoModel] = []
        guard let uid = userId else {
            fatalError()
        }
        db.collection("memos").whereField("userId", isEqualTo: uid).getDocuments { (snapshot, error) in
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
            completion(err == nil)
        }
    }
    
    func updateMemo(memo: MemoModel, completion: @escaping (Bool) -> Void) {
        guard let id = memo.id else {
            fatalError()
        }
        
        db.collection("memos").document(id).updateData([
            "text": memo.text,
            "imageURL": memo.imageURLStr
        ]) { error in
            completion(error == nil)
        }
    }
    
    func deleteMemo(memo: MemoModel, completion: @escaping (Bool) -> Void) {
        guard let id = memo.id else {
            fatalError()
        }
        db.collection("memos").document(id).delete() { error in
            completion(error == nil)
        }
    }
}
