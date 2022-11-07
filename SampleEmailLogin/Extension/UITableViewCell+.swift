//
//  UITableViewCell+.swift
//  SampleEmailLogin
//
//  Created by kasiwa on 2022/11/06.
//

import UIKit

extension UITableViewCell {
    static var nib: UINib { UINib(nibName: reuseIdentifier, bundle: nil) }
    static var reuseIdentifier: String { String(describing: Self.self) }
}
