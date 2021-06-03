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
            let weatherExpected = "À Moscow, de lat: 55.7522 et de long: 37.6156, le vent vient du 34, avec une vitesse de 3.62 m/s soit 13 km/h. La température est de 13 degré(s) avec une T.min de 11 degré(s), une T.max de 13 degrés et une température ressentie de 12 degrés. La pression est de 1025 ha. L'humidité est de 71%."
            
            var finalWeather = ""
            
            let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseWeather.weatherCorrectData, response: FakeResponseWeather.responseOK, error: nil))
            //When
            let expectation = XCTestExpectation(description: "Wait for queue change.")
            weatherService.getWeather(town: town) {result in
                
                switch result {
                
                case.success(let townReceived):
                    if let weatherReceived = townReceived[0] {
                    finalWeather = weatherReceived
                    }
                    
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
