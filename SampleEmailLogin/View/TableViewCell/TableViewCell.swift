//
//  TableViewCell.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/05.
//

import UIKit
import SwiftDate
import Kingfisher

class TableViewCell: UITableViewCell {
    @IBOutlet weak var memoImage: UIImageView!
    @IBOutlet weak var memoTextLabel: UILabel!
    @IBOutlet weak var memoCreatedAt: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memoImage.image = nil
        memoTextLabel.text = nil
        memoCreatedAt.text = nil
    }
    
    func configure(memo: MemoModel) {
        print(memo)
        if let url = URL(string: memo.imageURLStr) {
            print("URLから画像を読み込む")
            memoImage.kf.indicatorType = .activity
            memoImage.kf.setImage(with: url)
            print(memoImage)
        } else {
            print("画像がないので非表示")
            memoImage.isHidden = true
        }
        
        memoTextLabel.text = memo.text
        // memo.createdAtのData型を文字列にする
        let createdAt = "\(memo.createdAt.year)年\(memo.createdAt.month)月\(memo.createdAt.day)日"
        memoCreatedAt.text = createdAt
        print("cellの登録: \(memoCreatedAt.text)")
    }
}
