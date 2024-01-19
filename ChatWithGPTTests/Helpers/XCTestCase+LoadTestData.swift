//
//  String+LoadTestData.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 16/01/2024.
//

import XCTest

extension XCTestCase {
    func loadTestData(fileName: String, fileExtension: String) -> String {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: fileName, ofType: fileExtension)!
        do {
            return try String(contentsOfFile: path)
        }
        catch {
            fatalError("Can't find the file")
        }
    }
}
