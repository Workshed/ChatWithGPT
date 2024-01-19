//
//  MessageViewModelTests.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 19/01/2024.
//

import XCTest

import XCTest
@testable import ChatWithGPT

final class MessageViewModelTests: XCTestCase {

    func testInitialization() {
        let message = Message(role: .user, content: "Test")
        let viewModel = MessageViewModel(message: message, status: .sending)

        XCTAssertEqual(viewModel.messageText, "Test", "Message text should be initialized correctly")
        XCTAssertEqual(viewModel.role, .user, "Role should be initialized correctly")
        XCTAssertEqual(viewModel.status, .sending, "Status should be initialized correctly")
        XCTAssertEqual(viewModel.statusText, "sending", "Status text should be 'sending'")
        XCTAssertFalse(viewModel.statusHidden, "Status should not be hidden for 'sending' state")
    }

    func testStatusChange() {
        let message = Message(role: .user, content: "Test")
        var viewModel = MessageViewModel(message: message, status: .sending)

        viewModel.status = .sent
        XCTAssertEqual(viewModel.status, .sent, "Status should be updated to 'sent'")
        XCTAssertEqual(viewModel.statusText, "sent", "Status text should be updated to 'sent'")
        XCTAssertTrue(viewModel.statusHidden, "Status should be hidden for 'sent' state")

        viewModel.status = .failed
        XCTAssertEqual(viewModel.status, .failed, "Status should be updated to 'failed'")
        XCTAssertEqual(viewModel.statusText, "failed", "Status text should be updated to 'failed'")
        XCTAssertFalse(viewModel.statusHidden, "Status should not be hidden for 'failed' state")
    }
}
