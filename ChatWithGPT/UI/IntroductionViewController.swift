//
//  IntroductionViewController.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import UIKit
import Combine

protocol IntroductionViewControllerCoordinator: NSObject {
    func showDummyChat()
    func showGPTChat(apiKey: String)
}

class IntroductionViewController: UIViewController, StoryboardViewController {

    @IBOutlet private weak var apiKeyTextField: UITextField!
    @IBOutlet private weak var gptButton: UIButton!

    private let viewModel: IntroductionViewModel
    private let coordinator: IntroductionViewControllerCoordinator

    private var cancellables = Set<AnyCancellable>()

    init?(coder: NSCoder, viewModel: IntroductionViewModel, coordinator: IntroductionViewControllerCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a ViewModel and Coordinator.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose your AI"
        setupTextField()
        setupObservers()
    }

    private func setupTextField() {
        apiKeyTextField.delegate = self
    }

    private func setupObservers() {
        viewModel.$isGPTButtonEnabled.receive(on: RunLoop.main).sink(receiveValue: { [weak self] isEnabled in
            self?.gptButton.isEnabled = isEnabled
        }).store(in: &cancellables)
    }

    @IBAction private func dummyPressed() {
        coordinator.showDummyChat()
    }

    @IBAction private func gptPressed() {
        guard let apiKey = viewModel.apiKey else { return }
        coordinator.showGPTChat(apiKey: apiKey)
    }
}

// MARK: - Wrangle UITextField
extension IntroductionViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        viewModel.update(apiKey: prospectiveText)
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.update(apiKey: textField.text)
    }
}
