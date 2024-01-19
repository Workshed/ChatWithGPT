//
//  DataService.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import Foundation

class GPTNetworkManager: NetworkManager {
    
    private let session: NetworkSession
    private let apiKey: String

    init(session: NetworkSession = URLSession.shared, apiKey: String) {
        self.session = session
        self.apiKey = apiKey
    }

    func sendMessages(messages: [Message]) async throws -> Message {
        let url = makeURL()
        var urlRequest = makeURLRequest(url, apiKey: apiKey)
        let requestBody = makeRequestBody(messages)

        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await session.chatData(for: urlRequest)
        try validateHTTPResponse(response)

        return try decodeChatResponse(data)
    }

    private func makeURL() -> URL {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            fatalError("URL invalid")
        }
        return url
    }

    private func makeURLRequest(_ url: URL, apiKey: String) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }

    private func makeRequestBody(_ messages: [Message]) -> [String: Any] {
        let messageArray = messages.map { message in
            return ["role": message.role.rawValue, "content": message.content]
        }
        return ["model": "gpt-3.5-turbo", "messages": messageArray]
    }

    private func validateHTTPResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkManagerError.badHTTPResponse
        }
    }

    private func decodeChatResponse(_ data: Data) throws -> Message {
        let response = try JSONDecoder().decode(NetworkResponse.self, from: data)
        guard let message = response.choices.last?.message else {
            throw NetworkManagerError.noResponseReceived
        }
        return message
    }
}
