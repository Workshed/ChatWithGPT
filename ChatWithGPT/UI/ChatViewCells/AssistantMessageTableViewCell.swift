//
//  AssistantMessageTableViewCell.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import UIKit

class AssistantMessageTableViewCell: UITableViewCell, ReusableTableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageContainer: UIView!

    // MARK: - Public Properties

    var viewModel: MessageViewModel? {
        didSet {
            guard let viewModel else {
                messageLabel.text = ""
                return
            }

            messageLabel.text = viewModel.messageText
        }
    }

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainer.layer.cornerRadius = 12
    }
}
