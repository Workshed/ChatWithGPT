//
//  GPTChatRepositoryTests.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 16/01/2024.
//

@testable import ChatWithGPT
import XCTest

final class GPTChatRepositoryTests: XCTestCase {

    func testSend_WhenSuccessful_ReturnsCorrectResponse() async {
        let responseString = loadTestData(fileName: "DummyResponse", fileExtension: "json")
        let networkManager = NetworkManagerFactory.setUpNetworkManager(responseString: responseString)
        let chatRepository = GPTChatRepository(dataService: networkManager)

        do {
            let responseMessage = try await chatRepository.send(text: "What is 2 + 2?")
            XCTAssertEqual(responseMessage.content, "2 + 2 equals 4.")
        } catch {
            XCTFail("Expected success but received error: \(error)")
        }
    }

    func testSend_WhenBadHTTPResponse_ThrowsBadHTTPResponseError() async {
        let networkManager = NetworkManagerFactory.setUpNetworkManager(responseStatusCode: 400)
        let chatRepository = GPTChatRepository(dataService: networkManager)

        do {
            let _ = try await chatRepository.send(text: "What is 2 + 2?")
            XCTFail("Expected error but received a successful response")
        } catch {
            XCTAssertTrue(error is NetworkManagerError, "Expected NetworkManagerError but received \(error)")
            XCTAssertEqual(error as? NetworkManagerError, NetworkManagerError.badHTTPResponse)
        }
    }
}

