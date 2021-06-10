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
    private var session = URLSession(configuration: .default)
    
    init(session:URLSession) {
        self.session = session
    }
    /*
    private let urlBase = "http://data.fixer.io/api/latest?"
    private let authorization = "&access_key="
    private var code = Keys.change
    private var value = "USD"
    */
    private var task:URLSessionDataTask?
    
    func getConversion(stringAdress: String, infoBack: @escaping (Result<RatesOnLine,APIErrors>)->Void) {
        
        //let value = currencyName
        //let stringAdress = stringAdress
        
        guard let url = URL(string: stringAdress) else {
            infoBack(.failure(.invalidURL))
            return
        }
        
        let request = createConversionRequest(url:url)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil  else {
                    infoBack(.failure(.errorGenerated))
                    return
                }
                guard let dataUnwrapped = data else {
                    infoBack(.failure(.noData))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    infoBack(.failure(.invalidStatusCode))
                    return
                }
                do {
                    let data = try JSONDecoder().decode(RatesOnLine.self, from: dataUnwrapped)
                    infoBack(.success(data))
                    
                } catch {
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
