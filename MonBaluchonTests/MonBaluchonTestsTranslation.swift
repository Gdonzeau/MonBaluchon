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
        let translation = "Je m'appelle Guillaume"
        let translationService = TranslationService(
            session: URLSessionFake(data: FakeResponseTranslation.quoteCorrectData, response: FakeResponseTranslation.responseOK, error: nil))
        /*
        (
            session: URLSessionFake(data: FakeResponseTranslation.quoteIncorrectData, response: FakeResponseTranslation.responseOK, error: nil))
        */
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        if let httpString = translation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
        translationService.g(toLanguage: "en", text:httpString) { // text au lieu de httpString
            result in
            
            switch result {
            
            case.success(let valueOfChange):
                XCTAssertEqual(translation, valueOfChange)
            case.failure(let error):
                print(error)
            }
        }
        }
        
       // let translationService = TranslationService(
       //     session: URLSessionFake(data: FakeResponseTranslation.quoteCorrectData, response: FakeResponseTranslation.responseOK, error: nil))
        //When
        /*
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getConversion(currencyName: "RUB") { result in
            
            switch result {
            
            case.success(let valueOfChange):
                XCTAssertEqual(translation, valueOfChange)
            case.failure(let error):
            print(error)
            }
            */
            //Then
            
            //print("rate : \(rate)")
            
            
           // XCTAssertNotNil(rate)
            
            
           // XCTAssertEqual(author, quote!.author)
           // XCTAssertEqual(imageData, quote!.imageData)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
}
