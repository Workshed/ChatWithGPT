//
//  Coordinator.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import UIKit

protocol Coordinator: NSObject {
    var navigationController: UINavigationController { get set }
    func start()
}
