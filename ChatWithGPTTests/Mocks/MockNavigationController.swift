//
//  MockNavigationController.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 19/01/2024.
//

import UIKit

class MockNavigationController: UINavigationController {
    var mockPushedViewController: UIViewController?
    var mockPresentedViewController: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        mockPushedViewController = viewController
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        mockPresentedViewController = viewControllerToPresent
    }
}
