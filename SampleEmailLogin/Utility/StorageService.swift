//
//  StorageService.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/26.
//

import Foundation
import FirebaseCore
import FirebaseStorage
import SwiftDate

final class StorageService {
    static let shared: StorageService = .init()
    private init() {}
    
    private var storage = Storage.storage()
    
    // アップロード処理とダウンロード処理を分ける
    func uploadMemoImage(userId: String, imageData: Data, completion: @escaping (NSError?, StorageReference) -> Void) {
        let date = currentDateInJapan()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("user/\(userId)/image/\(date).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageRef.putData(imageData, metadata: metaData) { metaData, error in
            if let storageError = error as NSError? {
                completion(storageError, imageRef)
                return
            }
            completion(nil, imageRef)
        }
    }
    
    func downloadImage(imageRef: StorageReference, completion: @escaping (NSError?, URL) -> Void) {
        imageRef.downloadURL { url, error in
            guard let downloadURL = url else {
                return
            }
            if let storageError = error as NSError? {
                completion(storageError, downloadURL)
                return
            }
            completion(nil, downloadURL)
        }
    }
    
    private func currentDateInJapan() -> String {
        let japan = Region(calendar: Calendars.gregorian, zone: Zones.asiaTokyo, locale: Locales.japanese)
        SwiftDate.defaultRegion = japan
        let date = "\(Date().year)\(Date().month)\(Date().day)\(Date().hour)\(Date().minute)\(Date().second)"
        return date
    }
}
