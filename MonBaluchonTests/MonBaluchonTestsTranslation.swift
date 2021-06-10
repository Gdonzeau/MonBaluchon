//
//  MonBaluchonTestsTranslation.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 02/06/2021.
//

import Foundation

import XCTest
@testable import MonBaluchon

class MonBaluchonTestsTranlation: XCTestCase {
    
    func testGetTranslationShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        //Given
        let translationExpected = "My name is Guillaume."
        let urlAdress = "http://www.bonneAdresseUrl.com"
        var finalText = ""
        
        XCTAssertNotEqual(translationExpected, finalText)
        
        let translationService = TranslationService(
            session: URLSessionFake(data: FakeResponseTranslation.translationCorrectData, response: FakeResponseTranslation.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslation(stringAdress: urlAdress) {result in
            
            switch result {
            
            case.success(let translationReceived):
                finalText = translationReceived.data.translations[0].translatedText
                
                
            case.failure(let error):
                print(error)
            }
            //Then
            XCTAssertEqual(translationExpected, finalText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.00)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfInvalidUrl() {
        //Given
        let errorExpected:APIErrors = .invalidURL
        var errorReceived:APIErrors = .noError
        let urlAdress = "http://www.mauvaise Adresse Url.com"
        
        XCTAssertNotEqual(errorExpected, errorReceived)
        
        let translationService = TranslationService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslation(stringAdress: urlAdress) {result in
            
            switch result {
            
            case.success( _):
                XCTFail()
            case.failure(let error):
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.00)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfErrorReceived() {
        //Given
        let errorExpected:APIErrors = .errorGenerated
        var errorReceived:APIErrors = .noError
        let urlAdress = "http://www.bonneAdresseUrl.com"
        
        XCTAssertNotEqual(errorExpected, errorReceived)
        
        let translationService = TranslationService(
            session: URLSessionFake(data: FakeResponseTranslation.translationCorrectData, response: FakeResponseTranslation.responseOK, error: FakeResponseTranslation.error))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslation(stringAdress: urlAdress) {result in
            
            switch result {
            
            case.success( _):
                XCTFail()
            case.failure(let error):
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.00)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfNoData() {
        //Given
        let errorExpected:APIErrors = .noData
        var errorReceived:APIErrors = .noError
        let urlAdress = "http://www.bonneAdresseUrl.com"
        
        XCTAssertNotEqual(errorExpected, errorReceived)
        
        let translationService = TranslationService(
            session: URLSessionFake(data: nil, response: FakeResponseTranslation.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslation(stringAdress: urlAdress) {result in
            
            switch result {
            
            case.success( _):
                XCTFail()
            case.failure(let error):
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.00)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfInvalidStatusCode() {
        //Given
        let errorExpected:APIErrors = .invalidStatusCode
        var errorReceived:APIErrors = .noError
        let urlAdress = "http://www.bonneAdresseUrl.com"
        
        XCTAssertNotEqual(errorExpected, errorReceived)
        
        let translationService = TranslationService(
            session: URLSessionFake(data: FakeResponseTranslation.translationCorrectData, response: FakeResponseTranslation.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslation(stringAdress: urlAdress) {result in
            
            switch result {
            
            case.success( _):
                XCTFail()
            case.failure(let error):
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.00)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfIncorrectData() {
        //Given
        let errorExpected:APIErrors = .badFile
        var errorReceived:APIErrors = .noError
        let urlAdress = "http://www.bonneAdresseUrl.com"
        
        XCTAssertNotEqual(errorExpected, errorReceived)
        
        let translationService = TranslationService(
            session: URLSessionFake(data: FakeResponseTranslation.translationIncorrectData, response: FakeResponseTranslation.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.getTranslation(stringAdress: urlAdress) {result in
            
            switch result {
            
            case.success( _):
                XCTFail()
            case.failure(let error):
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.00)
    }
}
