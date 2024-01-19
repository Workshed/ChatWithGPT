//
//  AssistantMessageTableViewCell.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import UIKit

class AssistantMessageTableViewCell: UITableViewCell, ReusableTableViewCell {

    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageContainer: UIView!

    var viewModel: MessageViewModel? {
        didSet {
            guard let viewModel else {
                messageLabel.text = ""
                return
            }

            messageLabel.text = viewModel.messageText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainer.layer.cornerRadius = 12
    }
}
