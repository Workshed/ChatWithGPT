//
//  String+LoadTestData.swift
//  ChatWithGPTTests
//
//  Created by Daniel Leivers on 16/01/2024.
//

import XCTest

extension XCTestCase {

    /// Loads a given file in to a String for use in tests.
    /// - Parameters:
    ///   - fileName: The name of the file, i.e. for the file "DummyResponse.json" this would be "DummyResponse"
    ///   - fileExtension: The extension of the file, i.e. for the file "DummyResponse.json" this would be "json"
    /// - Returns: The contents of the file as a String
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
