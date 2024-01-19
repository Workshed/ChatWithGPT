//
//  NetworkDataServiceTests.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 15/01/2024.
//

@testable import ChatWithGPT
import XCTest

final class NetworkDataServiceTests: XCTestCase {

    func testSendMessages_WhenSuccessful_ReturnsCorrectResponse() async {
        let networkManager = NetworkManagerFactory.setUpNetworkManager(responseString: loadTestData(fileName: "DummyResponse", fileExtension: "json"))
        let messages = [Message(role: .user, content: "What is 2 + 2?")]

        do {
            let response = try await networkManager.sendMessages(messages: messages)
            XCTAssertEqual(response.content, "2 + 2 equals 4.")
        } catch {
            XCTFail("Expected success but received error: \(error)")
        }
    }

    func testSendMessages_WhenBadHTTPResponse_ThrowsBadHTTPResponseError() async {
        let networkManager = NetworkManagerFactory.setUpNetworkManager(responseStatusCode: 400)
        let messages = [Message(role: .user, content: "What is 2 + 2?")]

        do {
            let _ = try await networkManager.sendMessages(messages: messages)
            XCTFail("Expected error but received a successful response")
        } catch {
            XCTAssertTrue(error is NetworkManagerError, "Expected NetworkManagerError but received \(error)")
            XCTAssertEqual(error as? NetworkManagerError, NetworkManagerError.badHTTPResponse)
        }
    }

    func testSendMessages_WhenDecodingError_ThrowsDecodingError() async {
        let networkManager = NetworkManagerFactory.setUpNetworkManager(responseString: "This is not JSON",
                                                                       responseStatusCode: 200)
        let messages = [Message(role: .user, content: "What is 2 + 2?")]

        do {
            let _ = try await networkManager.sendMessages(messages: messages)
            XCTFail("Expected error but received a successful response")
        } catch is DecodingError {
            // Success: Correct error type caught
        } catch {
            XCTFail("Expected DecodingError but received \(error)")
        }
    }

    func testSendMessages_WhenNoResponseChoices_ThrowsNoResponseReceivedError() async {
        let responseString = loadTestData(fileName: "DummyResponseWithNoChoices", fileExtension: "json")
        let networkManager = NetworkManagerFactory.setUpNetworkManager(responseString: responseString,
                                                                       responseStatusCode: 200)
        let messages = [Message(role: .user, content: "What is 2 + 2?")]

        do {
            let _ = try await networkManager.sendMessages(messages: messages)
            XCTFail("Expected error but received a successful response")
        }  catch {
            XCTAssertTrue(error is NetworkManagerError, "Expected NetworkManagerError but received \(error)")
            XCTAssertEqual(error as? NetworkManagerError, NetworkManagerError.noResponseReceived)
        }
    }
}
