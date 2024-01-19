//
//  UITableView+Reusable.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import UIKit

/// Helper extensions to make loading UITableViewCell classes nicer
extension UITableView {
    func register<T: ReusableTableViewCell>(_ cellClass: T.Type) {
        register(cellClass.nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func dequeueReusableCell<T: ReusableTableViewCell>(withClass cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell of type \(String(describing: T.self))")
        }
        return cell
    }
}
