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
        
        func decodeData(snapshot: QueryDocumentSnapshot?) throws -> MemoModel {
            let decoder = Firestore.Decoder()
            return try decoder.decode(MemoModel.self, from: snapshot)
        }
    }
}
