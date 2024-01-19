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

    func updateButtonState(with userEnteredAPIKey: String?) {
        isGPTButtonEnabled = !(userEnteredAPIKey?.isEmpty ?? true)
        apiKey = userEnteredAPIKey
    }
}
