//
//  NetworkSession.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 16/01/2024.
//

import Foundation

// Defining this protocol allows us to create a mock source of data for testing
protocol NetworkSession {
    func chatData(for request: URLRequest) async throws -> (Data, URLResponse)
}

// This is our "default" implementation
extension URLSession: NetworkSession {
    func chatData(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await data(for: request)
    }
}
