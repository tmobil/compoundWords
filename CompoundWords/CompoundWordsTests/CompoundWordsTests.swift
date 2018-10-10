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
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheckfornonExistingFile() {
        DataManager.manager.findCompoundWordsFromValues(jsonFile: "sample") { (status) in
            XCTAssert(status == false, "Error in finding the file")
        }
    }

    func testCheckforInvalidJsonFile() {
        DataManager.manager.findCompoundWordsFromValues(jsonFile: "invalid") { (status) in
            XCTAssert(status == false, "Error in json format")
        }
    }

    func testCompoundWordsContains() {
        DataManager.manager.findCompoundWordsFromValues(jsonFile: "test_english") { (status) in
            XCTAssert(status == true, "Successfully completed")
            print(DataManager.manager.count)
            XCTAssert(DataManager.manager.count == 1, "Found wrong compound words")
        }
    }
}
