//
//  URLSessionMock.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 16/01/2024.
//

import Foundation
@testable import ChatWithGPT

class URLSessionMock: NetworkSession {

    var responseString: String = ""
    var responseStatusCode: Int = 200

    private let url = URL(string: "dummyurl.com")!

    func chatData(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let response = HTTPURLResponse(url: url,
                                             statusCode: responseStatusCode,
                                             httpVersion: nil,
                                             headerFields: nil)
        else { throw URLError(URLError.Code.badServerResponse) }

        return (responseString.data(using: .utf8)!, response)
    }
}
