//
//  FlatDataTests.swift
//  MojoTestTests
//
//  Created by Nano Anderson on 10/25/22.
//

import XCTest
@testable import MojoTest

final class FlatDataTests: XCTestCase {
    
    var jsonUrl: URL?
    var jsonData: Data?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        jsonUrl = Bundle(for: FlatDataTests.self).url(forResource: "takehome_mobile_data", withExtension: "json")!
        jsonData = try Data(contentsOf: jsonUrl!)
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
    
    func testOverallParser() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .ISO8601WithFractionalSeconds
        XCTAssertNoThrow(try decoder.decode(FlatData.self, from: jsonData!))
    }
    
    func testShoeHorns() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .ISO8601WithFractionalSeconds
        var flatData = try decoder.decode(FlatData.self, from: jsonData!)
        
        // Pre-shoehorn verification tests
        XCTAssert(flatData.stock.priceHistory == nil)
        for position in flatData.positions {
            XCTAssert(position.stock.currentPrice == nil)
            XCTAssert(position.stock.currentPriceFormatted == nil)
        }
        
        // Do the shoehorning, then test
        flatData = DataServiceStore.shoehorn(currentStockPriceDataFrom: flatData.stock, into: flatData)
        var foundTomBrady = false
        for position in flatData.positions {
            if position.stock == flatData.stock {
                foundTomBrady = true
                XCTAssert(position.stock.currentPrice == flatData.stock.currentPrice)
                XCTAssert(position.stock.currentPriceFormatted == flatData.stock.currentPriceFormatted)
            }
        }
        XCTAssert(foundTomBrady)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
