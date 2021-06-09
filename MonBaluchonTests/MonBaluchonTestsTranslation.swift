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
        let translationExpected = "My name is Guillaume"
        let originalText = "Je m'appelle Guillaume"
        var finalText = ""
        let language = "en"
        
        XCTAssertNotEqual(translationExpected, finalText)
        
        guard let httpString = originalText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        let translationService = TranslationService(
            session: URLSessionFake(data: FakeResponseTranslation.translationCorrectData, response: FakeResponseTranslation.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(toLanguage: language, text: httpString) {result in
            
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
    
    func testGetTranslationShouldPostFailedCallbackIfIncorrectData() {
        //Given
        let translationExpected = "My name is Guillaume"
        let originalText = "Je m'appelle Guillaume"
        var finalText = ""
        let language = "en"
        
        XCTAssertNotEqual(translationExpected, finalText)
        
        guard let httpString = originalText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        let translationService = TranslationService(
            session: URLSessionFake(data: FakeResponseTranslation.translationIncorrectData, response: FakeResponseTranslation.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(toLanguage: language, text: httpString) {result in
            
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
    
    func testGetTranslationShouldPostFailedCallbackIfIncorrectUrl() {
        //Given
        let language = "en"
        let httpString = "Machin Truc" // Bad url with space
        let errorExpected = APIErrors.invalidURL
        var errorReceived = APIErrors.noError
        XCTAssertNotEqual(errorExpected, errorReceived)
        let translationService = TranslationService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(toLanguage: language, text: httpString) {result in
            
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


