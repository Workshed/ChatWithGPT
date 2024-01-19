//
//  GPTChatRepository.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 19/01/2024.
//

import Foundation
import Combine

class GPTChatRepository: ChatRepository {
    var aiName: String = "GPT-3.5"

    private(set) var messages: [Message] = []

    let dataService: NetworkManager

    init(dataService: NetworkManager) {
        self.dataService = dataService
    }

    func send(text: String) async throws -> Message {
        let sentMessage = Message(role: .user, content: text)

        // In the real world we may not want to send the entire chat history, it will
        // at some point it will be too large for the tokens the model can accept.
        let sendingMessages = messages + [sentMessage]
        let responseMessage = try await dataService.sendMessages(messages: sendingMessages)

        messages.append(sentMessage)
        messages.append(responseMessage)

        return responseMessage
    }
}
