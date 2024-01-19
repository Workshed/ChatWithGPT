//
//  MessageTableViewCellViewModel.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import Foundation

enum MessageStatus: String {
    case sending, sent, failed
}

struct MessageViewModel: Identifiable {
    let id = UUID()
    let messageText: String
    let role: Role

    private(set) var statusText: String
    private(set) var statusHidden: Bool

    var status: MessageStatus {
        didSet {
            self.statusText = status.rawValue
            self.statusHidden = (status == .sent)
        }
    }

    init(message: Message, status: MessageStatus = .sent) {
        self.messageText = message.content
        self.role = message.role
        self.status = status
        self.statusText = status.rawValue
        self.statusHidden = (status == .sent)
    }
}
