//
//  MonBaluchonTestsWeather.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 03/06/2021.
//

import XCTest
@testable import MonBaluchon

class MonBaluchonTestsWeather: XCTestCase {
    
    func testGetConversionShouldPostFailedCallbackIfIncorrectUrl() {
        let errorExpected:APIErrors = .invalidURL
        var errorReceived:APIErrors = .noError
        let urlAdress = "Truc muche"
        XCTAssertNotEqual(errorExpected, errorReceived)
        // No URL to configure...
        let weatherService = WeatherService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        weatherService.getWeather(stringAdress: urlAdress) { result in
            
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
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConversionShouldPostFailedCallbackIfError() {
        let errorExpected:APIErrors = .errorGenerated
        var errorReceived:APIErrors = .noError
        let urlAdress = "http://www.bonneAdresseUrl.com"
        XCTAssertNotEqual(errorExpected, errorReceived)
        let weatherService = WeatherService(
            session: URLSessionFake(data: FakeResponseWeather.weatherCorrectData, response: FakeResponseWeather.responseOK, error: FakeResponseWeather.error))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        weatherService.getWeather(stringAdress: urlAdress) { result in
            
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
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConversionShouldPostFailedCallbackIfNoData() {
        let errorExpected:APIErrors = .noData
        var errorReceived:APIErrors = .noError
        let urlAdress = "http://www.bonneAdresseUrl.com"
        XCTAssertNotEqual(errorExpected, errorReceived)
        let weatherService = WeatherService(
            session: URLSessionFake(data: nil, response: FakeResponseWeather.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        weatherService.getWeather(stringAdress: urlAdress) { result in
            
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
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConversionShouldPostFailedCallbackIfIncorrectResponse() {
        let errorExpected:APIErrors = .invalidStatusCode
        var errorReceived:APIErrors = .noError
        let urlAdress = "http://www.bonneAdresseUrl.com"
        XCTAssertNotEqual(errorExpected, errorReceived)
        let weatherService = WeatherService(
            session: URLSessionFake(data: FakeResponseWeather.weatherCorrectData, response: FakeResponseWeather.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        weatherService.getWeather(stringAdress: urlAdress) { result in
            
            switch result {
            
            case.success( _):
                XCTFail()
                
            case.failure(let error):
                errorReceived = error
            }
            //Then
            XCTAssertEqual(errorExpected, errorReceived)
          //  XCTAssertEqual(currency, rate)
           
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConversionShouldPostFailedCallbackIfIncorrectData() {
        let errorExpected:APIErrors = .badFile
        var errorReceived:APIErrors = .noError
        let urlAdress = "http://www.bonneAdresseUrl.com"
        XCTAssertNotEqual(errorExpected, errorReceived)
        let weatherService = WeatherService(
            session: URLSessionFake(data: FakeResponseWeather.weatherIncorrectData, response: FakeResponseWeather.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        weatherService.getWeather(stringAdress: urlAdress) { result in
            
            switch result {
            
            case.success( _):
                XCTFail()
                
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
    
    func testGetConversionShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        //Given
        let weather = "Moscow, \n temperature : \n 19 degrees \n and weather is \n clear sky"
        var weatherToCheck = ""
        let urlAdress = "http://www.bonneAdresseUrl.com"
        XCTAssertNotEqual(weather, weatherToCheck)
        let weatherService = WeatherService(
            session: URLSessionFake(data: FakeResponseWeather.weatherCorrectData, response: FakeResponseWeather.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        weatherService.getWeather(stringAdress: urlAdress) { result in
            
            switch result {
            
            case.success(let data):
                let dataReceived = [data.name,data.main.temp,data.weather[0].weatherDescription] as [Any]
                weatherToCheck = "\(dataReceived[0]), \n temperature : \n \(Int(dataReceived[1] as! Double)) degrees \n and weather is \n \(dataReceived[2])"
                
            case.failure(let error):
            print(error)
            }
            //Then
            
            XCTAssertEqual(weather, weatherToCheck)
           
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
