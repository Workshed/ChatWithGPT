//
//  MockChatRepository.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 17/01/2024.
//

@testable import ChatWithGPT
import Foundation

class MockChatRepository: ChatRepository {
    var aiName: String = "Mock"
    var messages: [Message] = []
    var sendResult: Result<Message, Error>?

    func send(text: String) async throws -> Message {
        if let result = sendResult {
            switch result {
            case .success(let message):
                return message
            case .failure(let error):
                throw error
            }
        } else {
            fatalError("Set an expected result to use the mock")
        }
    }
}
