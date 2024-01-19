//
//  ReusableTableViewCell.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import UIKit

protocol ReusableTableViewCell where Self: UITableViewCell {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

/// Helper to make loading UITableViewCell classes nicer
extension ReusableTableViewCell {

    static var reuseIdentifier: String {
        let fullName = NSStringFromClass(self)
        return fullName.components(separatedBy: ".")[1]
    }

    static var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
