//
//  MemoModel.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/03.
//

import Foundation

struct MemoModel: Codable {
  var id: String
  var text: String
  var imageURLStr: String
  var createdAt: Date

  enum CodingKeys: String, CodingKey {
    case id = "id"
    case text = "text"
    case imageURLStr = "imageURLStr"
    case createdAt = "createdAt"
  }
  var imageURL: URL? { URL.init(string: imageURLStr) }
}
