//
//  ChatRepository.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import Foundation

protocol ChatRepository {
    var aiName: String { get }
    var messages: [Message] { get }

    func send(text: String) async throws -> Message
}
