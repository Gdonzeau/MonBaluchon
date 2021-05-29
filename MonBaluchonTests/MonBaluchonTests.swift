//
//  MonBaluchonTests.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 18/05/2021.
//

import XCTest
@testable import MonBaluchon

class MonBaluchonTests: XCTestCase {

    func testGivenStartConverionWhenStartThenUrlExists() {
        XCTAssertNotNil(currenciesAvailable)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfError() {
        //Given
        let conversionService = ConversionService(
            session: URLSessionFake(data: nil, response: nil, error: FakeResponseCurrencyRUB.error))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getConversion(currencyName: "RUB") { (success, rate)  in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
}
