//
//  WelcomeTableViewCell.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 17/01/2024.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell, ReusableTableViewCell {

    @IBOutlet private weak var welcomeLabel: UILabel!

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
