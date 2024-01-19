//
//  IntroductionViewModelTests.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 19/01/2024.
//

import XCTest
@testable import ChatWithGPT

final class IntroductionViewModelTests: XCTestCase {

    var viewModel: IntroductionViewModel!

    override func setUp() {
        super.setUp()
        viewModel = IntroductionViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testUpdateButtonState_WithNonEmptyAPIKey() {
        let nonEmptyAPIKey = "12345"

        viewModel.updateButtonState(with: nonEmptyAPIKey)

        XCTAssertTrue(viewModel.isGPTButtonEnabled, "Button should be enabled for non-empty API key.")
        XCTAssertEqual(viewModel.apiKey, nonEmptyAPIKey, "API key should be updated with user-entered value.")
    }

    func testUpdateButtonState_WithEmptyAPIKey() {
        viewModel.updateButtonState(with: "")

        XCTAssertFalse(viewModel.isGPTButtonEnabled, "Button should be disabled for empty API key.")
        XCTAssertEqual(viewModel.apiKey, "", "API key should be updated to an empty string.")
    }

    func testUpdateButtonState_WithNilAPIKey() {
        viewModel.updateButtonState(with: nil)

        XCTAssertFalse(viewModel.isGPTButtonEnabled, "Button should be disabled for nil API key.")
        XCTAssertNil(viewModel.apiKey, "API key should be nil.")
    }
}
