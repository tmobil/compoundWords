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
let viewController = ViewController()
    
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
        let isValid1 = viewController.checkWordIsCompoundWord(word: "tdtdtdtd")
        XCTAssert(isValid1 == false, "is complex word")
        
        let isValid2 = viewController.checkWordIsCompoundWord(word: "iendkdiewerj")
        XCTAssert(isValid2 == false, "is complex word")

    }
    
    func testCheckcompoundword() {
        let isValid1 = viewController.checkWordIsCompoundWord(word: "playground")
        XCTAssert(isValid1 == true, "is complex word")
        
        let isValid2 = viewController.checkWordIsCompoundWord(word: "sunflower")
        XCTAssert(isValid2 == true, "is complex word")
        
    }

    func testCheckWordsAvailableInArray() {
        viewController.checkForWordsInString(sentence: "Sunflower is living in playground")
        
        XCTAssert(viewController.compundWords.contains("Sunflower"), "compound words found")
        XCTAssert(viewController.compundWords.contains("playground"), "compound words found")

    }

}
