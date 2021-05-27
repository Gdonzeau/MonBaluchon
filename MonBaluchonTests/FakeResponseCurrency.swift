//
//  FakeResponseCurrency.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 28/05/2021.
//

import Foundation

class FakeResponseCurrency {
    
    static var quoteCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseCurrency.self)
        let url = bundle.url(forResource: "Conversion", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static let quoteIncorrectData = "erreur".data(using: .utf8)!
    
    class QuoteError: Error {}
    static let error = QuoteError()
}
