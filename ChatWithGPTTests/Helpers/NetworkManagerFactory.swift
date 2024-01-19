//
//  NetworkManagerFactory.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 17/01/2024.
//

@testable import ChatWithGPT
import Foundation

class NetworkManagerFactory {
    static func setUpNetworkManager(responseString: String? = nil, responseStatusCode: Int = 200) -> GPTNetworkManager {
        let mockSession = URLSessionMock()
        if let responseString {
            mockSession.responseString = responseString
        }
        mockSession.responseStatusCode = responseStatusCode
        let apiKey = "not_an_api_key"
        return GPTNetworkManager(session: mockSession, apiKey: apiKey)
    }
}
