//
//  MonBaluchonTestsWeather.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 03/06/2021.
//

import XCTest
@testable import MonBaluchon

class MonBaluchonTestsWeather: XCTestCase {
        
        func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
            //Given
            let town = "Moscow"
            let originalText = "Je m'appelle Guillaume"
            var finalText = ""
            let language = "en"
            guard let httpString = originalText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return
            }
            
            let weatherService = WeatherService(
                session: URLSessionFake(data: FakeResponseWeather.weatherCorrectData, response: FakeResponseWeather.responseOK, error: nil))
            //When
            let expectation = XCTestExpectation(description: "Wait for queue change.")
            weatherService.getTranslation(toLanguage: language, text: httpString) {result in
                
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
