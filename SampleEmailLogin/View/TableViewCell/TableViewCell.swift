//
//  TableViewCell.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/05.
//

import UIKit
import SwiftDate

class TableViewCell: UITableViewCell {
    @IBOutlet private weak var memoTextLabel: UILabel!
    @IBOutlet private weak var memoCreatedAt: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memoTextLabel.text = nil
        memoCreatedAt.text = nil
    }
    
    func configure(memo: MemoModel) {
        memoTextLabel.text = memo.text
        let createdAt = "\(memo.createdAt.year)年\(memo.createdAt.month)月\(memo.createdAt.day)日"
        memoCreatedAt.text = createdAt
    }
}
