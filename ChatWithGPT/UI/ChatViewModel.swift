//
//  ChatViewModel.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import Combine
import Foundation

class ChatViewModel {

    // MARK: - Private Properties

    private let chatRepository: ChatRepository

    private var cancellables = Set<AnyCancellable>()

    private var welcomeText: String {
        let formatString = NSLocalizedString("WelcomeText", comment: "Welcome message for chat")
        return String(format: formatString, chatRepository.aiName)
    }

    // MARK: - Public Properties

    /// The welcome message to display to the user
    var welcomeMessageViewModel: WelcomeViewModel {
        WelcomeViewModel(titleText: welcomeText)
    }
    
    /// The title to display
    let title: String

    @Published private(set) var messages: [MessageViewModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isSendButtonEnabled: Bool = false
    @Published private(set) var errorMessage: String? 

    // MARK: - Init

    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
        self.title = chatRepository.aiName

        loadMessagesFromRepository()
    }

    // MARK: - Public Methods

    /// Used to update the message text in the ViewModel for validation.
    /// - Parameter text: The (unsent) message text
    func update(messageText text: String?) {
        isSendButtonEnabled = !(text?.isEmpty ?? true)
    }

    /// Send the message text (note we could use the text from the `update(messageText)`
    /// function should we wish)
    /// - Parameter text: The message to send
    func send(text: String) async {
        isLoading = true
        let sendingMessage = MessageViewModel(message: Message(role: .user, content: text),
                                                           status: .sending)
        messages.append(sendingMessage)
        do {
            let responseMessage = try await chatRepository.send(text: text)
            if let index = self.messages.firstIndex(where: { $0.id == sendingMessage.id }) {
                self.messages[index].status = .sent
                self.messages.append(MessageViewModel(message: responseMessage))
            }
        }
        catch {
            guard let index = self.messages.firstIndex(where: { $0.id == sendingMessage.id }) else { return }
            self.messages[index].status = .failed
            // We should have better error handling in a real app, localised messages, etc.
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Private Methods

    /// Convert any existing messages in the repository in to MessageViewModels in our Publisher.
    private func loadMessagesFromRepository() {
        messages = chatRepository.messages.map({ message in
            MessageViewModel(message: message)
        })
    }
}
