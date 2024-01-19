//
//  AppCoordinatorTests.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 19/01/2024.
//

import XCTest
@testable import ChatWithGPT

final class AppCoordinatorTests: XCTestCase {
    var coordinator: AppCoordinator!
    var mockNavigationController: MockNavigationController!

    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        coordinator = AppCoordinator(navigationController: mockNavigationController)
    }

    override func tearDown() {
        coordinator = nil
        mockNavigationController = nil
        super.tearDown()
    }

    func testStart() {
        coordinator.start()
        XCTAssertNotNil(mockNavigationController.mockPushedViewController as? IntroductionViewController, "Coordinator should push IntroductionViewController")
    }

    func testShowDummyChat() {
        coordinator.showDummyChat()
        XCTAssertTrue(mockNavigationController.mockPresentedViewController is UINavigationController, "Dummy chat should be presented inside a UINavigationController")
        guard let navController = mockNavigationController.mockPresentedViewController as? UINavigationController else {
            XCTFail("Expected a UINavigationContoller")
            return
        }
        XCTAssertTrue(navController.viewControllers[0] is ChatViewController)
    }

    func testShowGPTChat() {
        coordinator.showGPTChat(apiKey: "TestAPIKey")
        XCTAssertTrue(mockNavigationController.mockPresentedViewController is UINavigationController, "GPT chat should be presented inside a UINavigationController")
        guard let navController = mockNavigationController.mockPresentedViewController as? UINavigationController else {
            XCTFail("Expected a UINavigationContoller")
            return
        }
        XCTAssertTrue(navController.viewControllers[0] is ChatViewController)
    }
}
