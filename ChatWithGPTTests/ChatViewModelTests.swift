//
//  ChatViewModelTests.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 17/01/2024.
//

@testable import ChatWithGPT
import XCTest

final class ChatViewModelTests: XCTestCase {
    var viewModel: ChatViewModel!
    var mockRepository: MockChatRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockChatRepository()
        viewModel = ChatViewModel(chatRepository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func testViewModel_InitializesWithEmptyMessages() {
        XCTAssertTrue(viewModel.messages.isEmpty, "Messages should be empty on initialization.")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false on initialization.")
        XCTAssertFalse(viewModel.isSendButtonEnabled, "isSendButtonEnabled should be false on initialization.")
    }

    func testSend_WhenSuccessful_AppendsSentAndResponseMessages() async {
        let testMessage = "Test Message"
        let expectedResponse = Message(role: .assistant, content: "Response")
        mockRepository.sendResult = .success(expectedResponse)

        await viewModel.send(text: testMessage)

        XCTAssertEqual(viewModel.messages.count, 2, "There should be two messages after sending: one sent and one response.")
        XCTAssertEqual(viewModel.messages.last?.messageText, expectedResponse.content, "The last message should be the response from the repository.")
    }

    func testSend_WhenFailure_RemainsOnlyWithSentMessage() async {
        let testMessage = "Test Message"
        mockRepository.sendResult = .failure(NSError(domain: "TestError", code: -1, userInfo: nil))

        await viewModel.send(text: testMessage)

        XCTAssertEqual(viewModel.messages.count, 1, "Message count should remain 1 on failure, retaining only the sent message.")
        XCTAssertEqual(viewModel.messages.first?.messageText, testMessage, "The first/only message should be the sent message.")
        XCTAssertEqual(viewModel.messages.first?.status, .failed, "The message status should be updated to 'failed'.")
    }

    func testViewModel_UpdateButtonState() {
        viewModel.updateButtonState(with: "Test")
        XCTAssertTrue(viewModel.isSendButtonEnabled, "isSendButtonEnabled should be true with non-empty text.")

        viewModel.updateButtonState(with: "")
        XCTAssertFalse(viewModel.isSendButtonEnabled, "isSendButtonEnabled should be false with empty text.")
    }

    func testViewModel_InitializesWithCorrectTitleAndWelcomeMessage() {
        XCTAssertEqual(viewModel.title, mockRepository.aiName, "Title should be set based on the repository's aiName.")
        XCTAssertNotNil(viewModel.welcomeMessageViewModel, "Welcome message view model should be initialized.")
    }
}
