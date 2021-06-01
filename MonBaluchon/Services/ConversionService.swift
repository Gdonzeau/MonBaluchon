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
    private static let urlBase = "http://data.fixer.io/api/latest?"
    private static let authorization = "&access_key="
    private static var code = "a7e3958d36cc451f0cfa1eb0c672a31a"
    private static var symbol = "&symbols="
    private static var value = "USD"
    private static var base = "&base="
    private static var valueBase = "EUR"// Don't change, restricted
    private static var final = "&callback=MY_FUNCTION"
    static var dicoDevises = ["USD":"usd","RUB":"rub"]
    
    static var url = URL(string: ConversionService.urlBase + ConversionService.authorization + ConversionService.code + ConversionService.symbol + ConversionService.value)!
    
    private var task:URLSessionDataTask?
    
    //func getConversion(currencyName:String,infoBack: @escaping (Bool,Double?)->Void) {
    func getConversion(currencyName:String,infoBack: @escaping (Result<Double,APIErrors>)->Void) {
        ConversionService.value = currencyName
        ConversionService.url = URL(string: ConversionService.urlBase + ConversionService.authorization + ConversionService.code + ConversionService.symbol + ConversionService.value)!
        let request = createConversionRequest()
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let dataUnwrapped = data {
                    do {
                        let welcomecourse = try JSONDecoder().decode(RatesOnLine.self, from: dataUnwrapped)
                        if let valueOfChange = welcomecourse.rates[ConversionService.value] {
                            infoBack(.success(valueOfChange))
                        } else {
                            print("Chais pas")
                        }
                        
                        /*
                        switch ConversionService.value {
                        case "USD" :
                            let welcomecourse = try JSONDecoder().decode(WelcomeCourseUSD.self, from: dataUnwrapped)
                            let valueOfChange = welcomecourse.rates.usd
                           // infoBack(true,valueOfChange)
                            infoBack(.success(valueOfChange))
                            
                        case "GBP" :
                            let welcomecourse = try JSONDecoder().decode(WelcomeCourseGBP.self, from: dataUnwrapped)
                            let valueOfChange = welcomecourse.rates.gbp
                            infoBack(.success(valueOfChange))
                            
                        case "RUB" :
                            let welcomecourse = try JSONDecoder().decode(WelcomeCourseRUB.self, from: dataUnwrapped)
                            let valueOfChange = welcomecourse.rates.rub
                            infoBack(.success(valueOfChange))
                            
                        default :
                            print("Erreur")
                            infoBack(.failure(.chépasquoi))
                        }
 */
                    } catch {
                        print("Problème")
                        infoBack(.failure(.badFile))
                    }
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
