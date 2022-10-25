//
//  AthleteTests.swift
//  MojoTestTests
//
//  Created by Nano Anderson on 10/24/22.
//

import XCTest
@testable import MojoTest

final class AthleteTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
    }
    
    func testParseName() throws {
        let fullName = "FirstName LastName"
        var parsedFullName = try Athlete.parsedNames(from: fullName)
        XCTAssert(parsedFullName.firstName == "FirstName")
        XCTAssert(parsedFullName.lastName == "LastName")
        
        let trimtestFullName = "   FirstName     LastName    "
        parsedFullName = try Athlete.parsedNames(from: trimtestFullName)
        XCTAssert(parsedFullName.firstName == "FirstName")
        XCTAssert(parsedFullName.lastName == "LastName")
        
        let multiFirstName = "First Name Many Names LastName"
        parsedFullName = try Athlete.parsedNames(from: multiFirstName)
        XCTAssert(parsedFullName.firstName == "First Name Many Names")
        XCTAssert(parsedFullName.lastName == "LastName")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
