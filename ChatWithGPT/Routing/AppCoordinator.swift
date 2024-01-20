//
//  AppCoordinator.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import UIKit

class AppCoordinator: NSObject, Coordinator {

    // MARK: - Public Properties

    var navigationController: UINavigationController

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public Properties

    func start() {
        let viewModel = IntroductionViewModel()
        let vc = IntroductionViewController.instantiate(from: .main) { coder in
            return IntroductionViewController(coder: coder, viewModel: viewModel, coordinator: self)
        }

        navigationController.pushViewController(vc, animated: true)
    }

    // MARK: - Private Properties

    private func showChat(chatRepository: ChatRepository) {
        let viewModel = ChatViewModel(chatRepository: chatRepository)
        let vc = ChatViewController.instantiate(from: .main) { coder in
            return ChatViewController(coder: coder, viewModel: viewModel, coordinator: self)
        }

        let chatNavigationController = UINavigationController(rootViewController: vc)
        chatNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(chatNavigationController, animated: true)
    }
}

// MARK: - IntroductionViewControllerCoordinator
extension AppCoordinator: IntroductionViewControllerCoordinator {
    func showDummyChat() {
        showChat(chatRepository: DummyChatRepository())
    }
    
    func showGPTChat(apiKey: String) {
        let networkManager = GPTNetworkManager(apiKey: apiKey)
        let repository = GPTChatRepository(dataService: networkManager)
        showChat(chatRepository: repository)
    }
}

// MARK: - ChatViewControllerCoordinator
extension AppCoordinator: ChatViewControllerCoordinator {
    func showError(message: String, from viewController: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(dismissAction)
        viewController.present(alertController, animated: true)
    }
    
    func closeChat() {
        navigationController.dismiss(animated: true)
    }
}
