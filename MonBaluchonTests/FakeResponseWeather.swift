//
//  FakeResponseWeather.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 03/06/2021.
//

import Foundation

class FakeResponseWeather {
    
    static var weatherCorrectData: Data {
        let bundle = Bundle(for: FakeResponseCurrencyRUB.self)
        let url = bundle.url(forResource: "ConversionRUB", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let weatherIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!


    
    // MARK: - Error
    class WeatherError: Error {}
    static let error = WeatherError()
}
