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
    private let urlBase = "http://data.fixer.io/api/latest?"
    private let authorization = "&access_key="
    private var code = Keys.change
    //private static var symbol = "&symbols="
    private var value = "USD"
    private var task:URLSessionDataTask?
    
    func getConversion(currencyName:String,infoBack: @escaping (Result<Double,APIErrors>)->Void) {
        
        value = currencyName
        let stringAdress = urlBase + authorization + code.rawValue
        
        guard let url = URL(string: stringAdress) else {
            print("Bad URL")
            return
        }
        
        let request = createConversionRequest(url:url)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async { [self] in
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
                    
                    if let valueOfChange = data.rates[self.value] {
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
    
    func createConversionRequest(url:URL) -> URLRequest {
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
}
