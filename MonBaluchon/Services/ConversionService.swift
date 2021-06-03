//
//  QuoteService.swift
//  Appel_Reseau
//
//  Created by Guillaume Donzeau on 01/05/2021.
//

import Foundation

class ConversionService {
    static var shared = ConversionService()
    private init() {}
    static var dicoCurrencies:[String:Double] = [:]
    
    private var session = URLSession(configuration: .default)
    
    init(session:URLSession) {
        self.session = session
    }
    private static let urlBase = "http://data.fixer.io/api/latest?"
    private static let authorization = "&access_key="
    private static var code = Keys.change
    private static var symbol = "&symbols="
    private static var value = "USD"
    private static var base = "&base="
    private static var valueBase = "EUR"// Don't change, restricted
    private static var final = "&callback=MY_FUNCTION"
    static var dicoDevises = ["USD":"usd","RUB":"rub"]// to delete
    
    static var url = URL(string: ConversionService.urlBase + ConversionService.authorization + ConversionService.code.rawValue)!
    
    private var task:URLSessionDataTask?
    
    func getConversion(currencyName:String,infoBack: @escaping (Result<Double,APIErrors>)->Void) {
        
        ConversionService.value = currencyName
        ConversionService.url = URL(string: ConversionService.urlBase + ConversionService.authorization + ConversionService.code.rawValue)! // + ConversionService.symbol + ConversionService.value)!
        let request = createConversionRequest()
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let dataUnwrapped = data else {
                    infoBack(.failure(.noData))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    infoBack(.failure(.noContact))
                    return
                }
                do {
                    let data = try JSONDecoder().decode(RatesOnLine.self, from: dataUnwrapped)
                    
                    if let valueOfChange = data.rates[ConversionService.value] {
                        ConversionService.dicoCurrencies = data.rates // Petite idée...
                        
                        infoBack(.success(valueOfChange))
                    } else {
                        print("Chais pas")
                    }
                    
                } catch {
                    print("Problème")
                    infoBack(.failure(.badFile))
                }
            }
        }
        task?.resume()
        
        print("Demande")
    }
    
    func createConversionRequest() -> URLRequest {
        var request = URLRequest(url:ConversionService.url)
        request.httpMethod = "POST"
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
}
