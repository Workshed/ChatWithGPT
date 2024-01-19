//
//  ChatResponse.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 17/01/2024.
//

import Foundation

struct NetworkResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]

    struct Usage: Decodable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }

    struct Choice: Decodable {
        let message: Message
        let finish_reason: String
    }
}
