//
//  DummyChatRepository.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 19/01/2024.
//

import Foundation

class DummyChatRepository: ChatRepository {
    var aiName: String = "Dummy"

    private(set) var messages: [Message] = [Message(role: .assistant, content: "This is a dummy message.")]

    func send(text: String) async throws -> Message {
        let sentMessage = Message(role: .user, content: text)
        messages.append(sentMessage)
        let responseMessage = Message(role: .assistant, content: "This is a dummy response.")
        messages.append(responseMessage)
        return responseMessage
    }
}
