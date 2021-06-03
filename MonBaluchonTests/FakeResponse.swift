//
//  FakeResponse.swift
//  MonBaluchonTests
//
//  Created by Guillaume Donzeau on 03/06/2021.
//

import Foundation

class FakeResponse {
    
    static var stringJson: String {
        get {
            return ""
        } set {
            
        }
    }
    
    init(json:String) {
        FakeResponse.stringJson = json
    }
    
    static var currencyCorrectData: Data {
        let bundle = Bundle(for: FakeResponse.self)
        let url = bundle.url(forResource: stringJson, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let curencyIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!


    
    // MARK: - Error
    class CurrencyError: Error {}
    static let error = CurrencyError()
}
