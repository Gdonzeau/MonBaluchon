//
//  MonBaluchonTestsWeather.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 03/06/2021.
//

import XCTest
@testable import MonBaluchon

class MonBaluchonTestsWeather: XCTestCase {
    var whatWeather = WhatWeatherViewController()
        
        func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
            //Given
            let town = "Moscow"
            let weatherExpected = "Moscow, \n temperature : \n 19 degrees \n and weather is \n clear sky"
            
            var finalWeather = ""
            
            let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseWeather.weatherCorrectData, response: FakeResponseWeather.responseOK, error: nil))
            //When
            let expectation = XCTestExpectation(description: "Wait for queue change.")
            weatherService.getWeather(town: town) {result in
                
                switch result {
                
                case.success(let townReceived):
                    let weatherData = [townReceived.name,townReceived.main.temp,townReceived.weather[0].weatherDescription] as [Any]
                    
                    finalWeather = self.whatWeather.buildStringAnswer(result: weatherData)
                    
                case.failure(let error):
                    print(error)
                }
                //Then
                XCTAssertEqual(weatherExpected, finalWeather)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.00)
        }
}
