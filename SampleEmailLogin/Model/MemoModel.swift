//
//  MemoModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/03.
//

import Foundation
import FirebaseFirestoreSwift

struct MemoModel: Codable {
  @DocumentID var id: String?
  var text: String
  var userId: String
  var createdAt: Date
  var imageURLStr: String

  enum CodingKeys: String, CodingKey {
    case id
    case text
    case userId
    case createdAt
    case imageURLStr = "imageURL"
  }
  var imageURL: URL? { URL.init(string: imageURLStr) }
}
