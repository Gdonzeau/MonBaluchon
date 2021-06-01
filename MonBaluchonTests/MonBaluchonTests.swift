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
        conversionService.getConversion(currencyName: "") { (success, rate)  in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfNoData() {
        //Given
        let conversionService = ConversionService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getConversion(currencyName: "") { (success, rate) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        
      //  wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfIncorrectResponse() {
        //Given
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.quoteIncorrectData, response: FakeResponseCurrencyRUB.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getConversion(currencyName: "") { (success, rate) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(rate)
            expectation.fulfill()
        }
        
      //  wait(for: [expectation], timeout: 0.01)
    }
    // Test Image
    func testGetImageShouldPostFailedCallbackIfError() {
        //Given
        let conversionService = ConversionService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getConversion(currencyName: "") { (success, quote) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
      //  wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetImageShouldPostFailedCallbackIfNoData() {
        //Given
        let conversionService = ConversionService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getConversion(currencyName: "") { (success, quote) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
      //  wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetImageShouldPostFailedCallbackIfIncorrectResponse() {
        //Given
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.quoteCorrectData , response: FakeResponseCurrencyRUB.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getConversion(currencyName: "") { (success, quote) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
      //  wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfIncorrectData() {
        //Given
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.quoteIncorrectData, response: FakeResponseCurrencyRUB.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getConversion(currencyName: "") { (success, quote) in
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
      //  wait(for: [expectation], timeout: 0.01)
    }
    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        //Given
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.quoteCorrectData, response: FakeResponseCurrencyRUB.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getConversion(currencyName: "") { (success, rate) in
            //Then
            let currency = 0.0//89.282326
            print("rate : \(rate)")
          //  let author = "Napoleon Bonaparte "
          //  let imageData = "image".data(using: .utf8)!
            
            XCTAssertTrue(success)
            XCTAssertNotNil(rate)
            
            XCTAssertEqual(currency, rate)
           // XCTAssertEqual(author, quote!.author)
           // XCTAssertEqual(imageData, quote!.imageData)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
}
