//
//  MonBaluchonTests.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 18/05/2021.
//

import XCTest
@testable import MonBaluchon

class MonBaluchonTestsCurrency: XCTestCase {

    func testGivenStartConversionWhenStartThenUrlExists() {
        XCTAssertNotNil(currenciesAvailable)
    }
    
    func testGetConversionShouldPostFailedCallbackIfError() {
        let errorExpected:APIErrors = .badFile
        var errorReceived:APIErrors = .noError
        XCTAssertNotEqual(errorExpected, errorReceived)
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.currencyCorrectData, response: FakeResponseCurrencyRUB.responseOK, error: FakeResponseCurrencyRUB.error))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        conversionService.getConversion(currencyName: "RUB") { result in
            
            switch result {
            
            case.success( _):
                print("Youpi")
                
            case.failure(let error):
            print("Pas Youpi")
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfNoData() {
        let errorExpected:APIErrors = .noData
        var errorReceived:APIErrors = .noError
        XCTAssertNotEqual(errorExpected, errorReceived)
        let conversionService = ConversionService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        conversionService.getConversion(currencyName: "RUB") { result in
            
            switch result {
            
            case.success( _):
                print("Youpi")
                
            case.failure(let error):
            print("Pas Youpi")
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfIncorrectResponse() {
        let errorExpected:APIErrors = .noContact
        var errorReceived:APIErrors = .noError
        XCTAssertNotEqual(errorExpected, errorReceived)
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.currencyCorrectData, response: FakeResponseCurrencyRUB.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        conversionService.getConversion(currencyName: "RUB") { result in
            
            switch result {
            
            case.success( _):
                print("Youpi")
                
            case.failure(let error):
            print("Pas Youpi")
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
          //  XCTAssertEqual(currency, rate)
           
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    // Test Image
    func testGetImageShouldPostFailedCallbackIfError() {
        let errorExpected:APIErrors = .noContact
        var errorReceived:APIErrors = .noError
        XCTAssertNotEqual(errorExpected, errorReceived)
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.currencyCorrectData, response: FakeResponseCurrencyRUB.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        conversionService.getConversion(currencyName: "RUB") { result in
            
            switch result {
            
            case.success( _):
                print("Youpi")
                
            case.failure(let error):
            print("Pas Youpi")
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
          //  XCTAssertEqual(currency, rate)
           
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetImageShouldPostFailedCallbackIfNoData() {
        let errorExpected:APIErrors = .noContact
        var errorReceived:APIErrors = .noError
        XCTAssertNotEqual(errorExpected, errorReceived)
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.currencyCorrectData, response: FakeResponseCurrencyRUB.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        conversionService.getConversion(currencyName: "RUB") { result in
            
            switch result {
            
            case.success( _):
                print("Youpi")
                
            case.failure(let error):
            print("Pas Youpi")
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
          //  XCTAssertEqual(currency, rate)
           
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetImageShouldPostFailedCallbackIfIncorrectResponse() {
        let errorExpected:APIErrors = .noContact
        var errorReceived:APIErrors = .noError
        XCTAssertNotEqual(errorExpected, errorReceived)
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.currencyCorrectData, response: FakeResponseCurrencyRUB.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        conversionService.getConversion(currencyName: "RUB") { result in
            
            switch result {
            
            case.success( _):
                print("Youpi")
                
            case.failure(let error):
            print("Pas Youpi")
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
          //  XCTAssertEqual(currency, rate)
           
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetgetCurrencyShouldPostFailedCallbackIfIncorrectData() {
        let errorExpected:APIErrors = .noContact
        var errorReceived:APIErrors = .noError
        XCTAssertNotEqual(errorExpected, errorReceived)
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.currencyCorrectData, response: FakeResponseCurrencyRUB.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        conversionService.getConversion(currencyName: "RUB") { result in
            
            switch result {
            
            case.success( _):
                print("Youpi")
                
            case.failure(let error):
            print("Pas Youpi")
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
          //  XCTAssertEqual(currency, rate)
           
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        //Given
        let currency = 89.282326
        var rate = 0.00
        XCTAssertNotEqual(currency, rate)
        let conversionService = ConversionService(
            session: URLSessionFake(data: FakeResponseCurrencyRUB.currencyCorrectData, response: FakeResponseCurrencyRUB.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        conversionService.getConversion(currencyName: "RUB") { result in
            
            switch result {
            
            case.success(let valueOfChange):
                rate = valueOfChange
                
            case.failure(let error):
            print(error)
            }
            //Then
            XCTAssertEqual(result, .success(currency))
            XCTAssertEqual(currency, rate)
           
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
}
