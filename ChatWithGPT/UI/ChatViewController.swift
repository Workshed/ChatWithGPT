//
//  ChatViewController.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import UIKit
import Combine

protocol ChatViewControllerCoordinator: NSObject {
    func closeChat()
    func showError(message: String, from viewController: UIViewController)
}

class ChatViewController: UIViewController, StoryboardViewController {

    // MARK: - Private Methods

    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!

    private var closeButton: UIBarButtonItem!

    private var cancellables = Set<AnyCancellable>()

    private let viewModel: ChatViewModel
    private let coordinator: ChatViewControllerCoordinator

    // MARK: - Init

    init?(coder: NSCoder, viewModel: ChatViewModel, coordinator: ChatViewControllerCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a ViewModel and Coordinator.")
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title

        setupNavigationBar()
        setupTable()
        setupTextField()
        setupObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
        messageTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true

        closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                                  target: self,
                                                  action: #selector(closePressed))
        navigationItem.rightBarButtonItem = closeButton
    }

    private func setupTable() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTriggered))
        tableView.addGestureRecognizer(tapGesture)

        tableView.dataSource = self

        tableView.register(WelcomeTableViewCell.self)
        tableView.register(UserMessageTableViewCell.self)
        tableView.register(AssistantMessageTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func setupTextField() {
        messageTextField.delegate = self
    }

    @objc private func tapGestureTriggered() {
        dismissKeyboard()
    }

    private func setupObservers() {
        viewModel.$messages.receive(on: RunLoop.main).sink(receiveValue: { [weak self] messages in
            self?.tableView.reloadData()
            self?.scrollToNewestMessage()
        }).store(in: &cancellables)

        viewModel.$isLoading.receive(on: RunLoop.main).sink(receiveValue: { [weak self] isLoading in
            self?.messageTextField.text = ""
            self?.messageTextField.isEnabled = !isLoading
        }).store(in: &cancellables)

        viewModel.$isSendButtonEnabled.receive(on: RunLoop.main).sink(receiveValue: { [weak self] isEnabled in
            self?.sendButton.isEnabled = isEnabled
        }).store(in: &cancellables)

        viewModel.$errorMessage.receive(on: RunLoop.main).sink(receiveValue: { [weak self] errorMessage in
            guard let self, let errorMessage else { return }
            self.coordinator.showError(message: errorMessage, from: self)
        }).store(in: &cancellables)
    }

    @IBAction private func sendPressed() {
        guard let message = messageTextField.text else { return }
        Task {
            await viewModel.send(text: message)
        }
    }

    private func scrollToNewestMessage() {
        guard viewModel.messages.count > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: viewModel.messages.count - 1, section: Section.messages.rawValue),
                              at: .bottom, animated: false)
    }

    @objc private func closePressed() {
        coordinator.closeChat()
    }
}

// MARK: - TableView handling
extension ChatViewController: UITableViewDataSource {

    // Allows us to refer to UITableView sections with a variable rather than integers
    private enum Section: Int {
        case welcome = 0
        case messages
        case total
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.welcome.rawValue {
            return createWelcomeCell(for: indexPath)
        }
        else {
            return createMessageCell(for: indexPath)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.total.rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.welcome.rawValue {
            return 1
        }
        else {
            return viewModel.messages.count
        }
    }

    private func createWelcomeCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: WelcomeTableViewCell.self, for: indexPath)
        cell.viewModel = viewModel.welcomeMessageViewModel
        return cell
    }

    private func createMessageCell(for indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.messages[indexPath.row]
        switch cellViewModel.role {
        case .user:
            return createUserMessageCell(for: indexPath)
        case .assistant:
            return createAssistantMessageCell(for: indexPath)
        }
    }

    private func createUserMessageCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UserMessageTableViewCell.self, for: indexPath)
        cell.viewModel = viewModel.messages[indexPath.row]
        return cell
    }

    private func createAssistantMessageCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: AssistantMessageTableViewCell.self, for: indexPath)
        cell.viewModel = viewModel.messages[indexPath.row]
        return cell
    }
}

// MARK: - Handle keyboard appearing/disappearing
private extension ChatViewController {

    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func animateKeyboardChanges(keyboardFrame: CGRect, animationDuration: Float, animationCurve: Int, showKeyboard: Bool) {
        let bottomSafeAreaHeight = view.safeAreaInsets.bottom
        let viewCurve = UIView.AnimationCurve(rawValue: animationCurve) ?? .easeInOut
        let options = UIView.animationOptionsForCurve(viewCurve)

        UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0, options: options, animations: {
            self.bottomConstraint.constant = showKeyboard ? (keyboardFrame.height - bottomSafeAreaHeight) : 0
            self.view.layoutIfNeeded()
            if showKeyboard {
                self.scrollToNewestMessage()
            }
        }, completion: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float,
              let animationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }

        animateKeyboardChanges(keyboardFrame: keyboardFrame, animationDuration: animationDuration, animationCurve: animationCurve, showKeyboard: true)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float,
              let animationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        animateKeyboardChanges(keyboardFrame: keyboardFrame, animationDuration: animationDuration, animationCurve: animationCurve, showKeyboard: false)
    }

    private func dismissKeyboard() {
        messageTextField.resignFirstResponder()
    }
}

// MARK: - Wrangle UITextField
extension ChatViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        viewModel.update(messageText: prospectiveText)
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.update(messageText: textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == messageTextField {
            sendPressed()
        }

        return true
    }
}
