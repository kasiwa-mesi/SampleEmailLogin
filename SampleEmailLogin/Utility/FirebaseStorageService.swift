//
//  FirebaseStorageService.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/08.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SwiftDate

final class FirebaseStorageService {
    static let shared: FirebaseStorageService = .init()
    private init() {}
    
    private var storage = Storage.storage()
    
    // アップロード処理とダウンロード処理を分ける
    func uploadMemoImage(userId: String, imageData: Data, completion: @escaping (Bool, StorageReference) -> Void) {
        let date = currentDateInJapan()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("user/\(userId)/image/\(date).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageRef.putData(imageData, metadata: metaData) { metaData, error in
            if let error = error {
                print("アップロードに失敗しました: \(error)")
                completion(false, imageRef)
            } else {
                completion(true, imageRef)
            }
        }
    }
    
    func downloadImage(imageRef: StorageReference, completion: @escaping (URL) -> Void) {
        imageRef.downloadURL { url, error in
            if let error = error {
                print("ダウンロードに失敗しました")
                print(error)
                print(error.localizedDescription)
            } else {
                guard let downloadURL = url else {
                    fatalError()
                }
                print("ダウンロードに成功しました")
                completion(downloadURL)
            }
        }
    }
    
    private func currentDateInJapan() -> String {
        let japan = Region(calendar: Calendars.gregorian, zone: Zones.asiaTokyo, locale: Locales.japanese)
        SwiftDate.defaultRegion = japan
        let date = "\(Date().year)\(Date().month)\(Date().day)\(Date().hour)\(Date().minute)\(Date().second)"
        return date
    }
}
