//
//  FakeResponseCurrency.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 28/05/2021.
//

import Foundation

class FakeResponseCurrencyRUB {
    
    static var quoteCorrectData: Data {
        let bundle = Bundle(for: FakeResponseCurrencyRUB.self)
        let url = bundle.url(forResource: "ConversionRUB", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let quoteIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!


    
    // MARK: - Error
    class QuoteError: Error {}
    static let error = QuoteError()
}
