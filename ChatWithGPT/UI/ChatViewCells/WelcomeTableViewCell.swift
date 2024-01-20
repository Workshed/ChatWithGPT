//
//  WelcomeTableViewCell.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 17/01/2024.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell, ReusableTableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var welcomeLabel: UILabel!

    // MARK: - Public Properties

    var viewModel: WelcomeViewModel? {
        didSet {
            guard let viewModel else {
                welcomeLabel.text = ""
                return
            }

            welcomeLabel.text = viewModel.titleText
        }
    }
}
