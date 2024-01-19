//
//  NetworkManager.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 19/01/2024.
//

import Foundation

protocol NetworkManager {
    func sendMessages(messages: [Message]) async throws -> Message
}

enum NetworkManagerError: Error {
    case missingAPIKey
    case badHTTPResponse
    case noResponseReceived
}
