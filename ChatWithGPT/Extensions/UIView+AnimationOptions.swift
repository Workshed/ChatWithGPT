//
//  UIView+AnimationOptions.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import UIKit

extension UIView {
    static func animationOptionsForCurve(_ curve: UIView.AnimationCurve) -> UIView.AnimationOptions {
        switch curve {
        case .easeInOut:
            return .curveEaseInOut
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .linear:
            return .curveLinear
        @unknown default:
            return .curveLinear
        }
    }
}
