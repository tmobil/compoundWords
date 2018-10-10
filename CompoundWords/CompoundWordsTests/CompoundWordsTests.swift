//
//  CompoundWordsTests.swift
//  CompoundWordsTests
//
//  Created by soma gorinta on 10/3/18.
//  Copyright © 2018 soma gorinta. All rights reserved.
//

import XCTest
@testable import CompoundWords

class CompoundWordsTests: XCTestCase {
let viewController = DictionaryKeysTableViewController()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheckfornonExistingFile() {
        let data = viewController.readDataFromJsonFile(fileName: "sample")
        XCTAssert(data.errorKey == "file not found", "error on reading the file")
    }
    
    func testCheckforInvalidJsonFile() {
        let data = viewController.readDataFromJsonFile(fileName: "invalid")
        XCTAssert(data.errorKey == "The data couldn’t be read because it isn’t in the correct format.", "error on reading the file")
    }
    
    func testCheckforvalidJsonFile() {
        let data = viewController.readDataFromJsonFile(fileName: "english")
        XCTAssert(data.errorKey == nil, "file reading successfull")
    }
    
    func testChecknoncompoundword() {
        viewController.values = ["a", "b", "c"]
        
        let isValid1 = viewController.checkWordIsCompoundWord(word: "sun")
        XCTAssert(isValid1 == false, "is complex word")
        
        let isValid2 = viewController.checkWordIsCompoundWord(word: "nut")
        XCTAssert(isValid2 == false, "is complex word")

    }
    
    func testCheckcompoundword() {
        viewController.values = ["sun", "flower", "sunflower"]
        
        let isValid1 = viewController.checkWordIsCompoundWord(word: "sun")
        XCTAssert(isValid1 == false, "is complex word")
        
        let isValid2 = viewController.checkWordIsCompoundWord(word: "flower")
        XCTAssert(isValid2 == false, "is complex word")
        
        let isValid3 = viewController.checkWordIsCompoundWord(word: "sunflower")
        XCTAssert(isValid3 == true, "is complex word")
        
        
    }
    
    func testIsWordExistsInKeys() {
        viewController.values = ["sun", "flower", "sunflower"]
        
        let isValid1 = viewController.isWordExistsInKeys(word: "Sun")
        XCTAssert(isValid1 == true, "is complex word")
        
        let isValid2 = viewController.isWordExistsInKeys(word: "abc")
        XCTAssert(isValid2 == false, "is complex word")
        
    }
    
    func testCompoundWordsContains() {
        viewController.values = ["sun", "flower", "sunflower"]
        
        viewController.findCompoundWordsFromValues()
        
        XCTAssert(viewController.compundWords.contains("sunflower"), "is complex word")
        XCTAssert(!viewController.compundWords.contains("sun"), "is complex word")
    }
}
