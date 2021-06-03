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
    
    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        //Given
        let translationExpected = "My name is Guillaume"
        let originalText = "Je m'appelle Guillaume"
        //var textSent = ""
        var finalText = ""
        let language = "en"
        guard let httpString = originalText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        let translationService = TranslationService(
            session: URLSessionFake(data: FakeResponseTranslation.quoteCorrectData, response: FakeResponseTranslation.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(toLanguage: language, text: httpString) {result in
            
            switch result {
            
            case.success(let translationReceived):
                finalText = translationReceived
                
            case.failure(let error):
                print(error)
            }
            //Then
            XCTAssertEqual(translationExpected, finalText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.00)
    }
    
}
