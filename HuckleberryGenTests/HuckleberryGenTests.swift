//
//  HuckleberryGenTests.swift
//  HuckleberryGenTests
//
//  Created by David Vallas on 7/11/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import XCTest
@testable import HuckleberryGen

class HuckleberryGenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFindModels() {
        
        let expectation = expectationWithDescription("updateModels")
        
        ModelFinder.models(path: "/") { (models) -> Void in
            XCTAssertTrue(models.count > 0, "No Models Found")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    
 
    
}
