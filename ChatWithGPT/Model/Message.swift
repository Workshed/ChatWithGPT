//
//  Message.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import Foundation

struct Message: Decodable {
    let role: Role
    let content: String
}
