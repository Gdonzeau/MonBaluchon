//
//  MonBaluchonTests.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 18/05/2021.
//

import XCTest
@testable import MonBaluchon

class MonBaluchonTestsCurrency: XCTestCase {

    func testGivenStartConverionWhenStartThenUrlExists() {
        XCTAssertNotNil(currenciesAvailable)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfError() {
        //Given
        let conversionService = ConversionService(
            session: URLSessionFake(data: nil, response: nil, error: FakeResponseCurrencyRUB.error))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getConversion(currencyName: "") { result  in
            //Then
           // XCTAssertFalse(success)
           // XCTAssertNil(rate)
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
        conversionService.getConversion(currencyName: "") { result in
            //Then
           // XCTAssertFalse(success)
           // XCTAssertNil(rate)
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
        conversionService.getConversion(currencyName: "") { result in
            //Then
           // XCTAssertFalse(success)
           // XCTAssertNil(rate)
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
        conversionService.getConversion(currencyName: "") { result in
            //Then
           // XCTAssertFalse(success)
           // XCTAssertNil(quote)
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
        conversionService.getConversion(currencyName: "") { result in
            //Then
         //   XCTAssertFalse(success)
         //   XCTAssertNil(quote)
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
        conversionService.getConversion(currencyName: "") { result in
            //Then
           // XCTAssertFalse(success)
           // XCTAssertNil(quote)
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
        conversionService.getConversion(currencyName: "") { result in
            //Then
           // XCTAssertFalse(success)
           // XCTAssertNil(quote)
            expectation.fulfill()
        }
        
      //  wait(for: [expectation], timeout: 0.01)
    }
    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        //Given
        let currency = 89.282326
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.quoteCorrectData, response: FakeResponseCurrencyRUB.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getConversion(currencyName: "RUB") { result in
            
            switch result {
            
            case.success(let valueOfChange):
                XCTAssertEqual(currency, valueOfChange)
            case.failure(let error):
            print(error)
            }
            //Then

           // XCTAssertNotNil(rate)
           // XCTAssertEqual(author, quote!.author)
           // XCTAssertEqual(imageData, quote!.imageData)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
}
