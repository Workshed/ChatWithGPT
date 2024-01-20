//
//  NetworkManagerFactory.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 17/01/2024.
//

@testable import ChatWithGPT
import Foundation

class NetworkManagerFactory {

    /// Sets up a mock network response to return a given response string and/or status code.
    /// - Parameters:
    ///   - responseString: The response to return
    ///   - responseStatusCode: The status code to return
    /// - Returns: A GPTNetworkManager for use in tests.
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
