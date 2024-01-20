//
//  IntroductionViewModel.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 18/01/2024.
//

import Foundation
import Combine

class IntroductionViewModel {

    @Published private(set) var isGPTButtonEnabled: Bool = false

    private(set) var apiKey: String?

    /// Used to update the API key in the ViewModel for validation.
    /// - Parameter userEnteredAPIKey: The API key to use for ChatGPT
    func update(apiKey userEnteredAPIKey: String?) {
        isGPTButtonEnabled = !(userEnteredAPIKey?.isEmpty ?? true)
        apiKey = userEnteredAPIKey
    }
}
