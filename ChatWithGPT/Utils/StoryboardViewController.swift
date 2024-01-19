//
//  StoryboardViewController.swift
//  ChatWithGPT
//
//  Created by Daniel Leivers on 15/01/2024.
//

import UIKit

protocol StoryboardViewController {
    static func instantiate(from storyboard: AppStoryboard, creator: ((NSCoder) -> UIViewController?)?) -> Self
}

/// Helper function to make loading ViewControllers from a Storyboard  a little bit nicer
extension StoryboardViewController where Self: UIViewController {
    static func instantiate(from storyboard: AppStoryboard, creator: ((NSCoder) -> UIViewController?)? = nil) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(identifier: className, creator: creator) as! Self
    }
}
