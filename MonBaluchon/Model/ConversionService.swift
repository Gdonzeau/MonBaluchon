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
    //var request = URLRequest(url:url)
    
    private var task:URLSessionDataTask?
    
    //func getConversion(currencyName:String,infoBack: @escaping (Bool,String?,String?,Double?)->Void) {
        func getConversion(currencyName:String,infoBack: @escaping (Bool,Double?)->Void) {
        ConversionService.value = currencyName
        ConversionService.url = URL(string: ConversionService.urlBase + ConversionService.authorization + ConversionService.code + ConversionService.symbol + ConversionService.value)!
        let request = createConversionRequest()
        //request = URLRequest(url:ConversionService.url)
        //request.httpMethod = "POST"
        //let body = "method=getQuote&lang=en&format=json"
        //request.httpBody = body.data(using: .utf8)
        //let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let dataUnwrapped = data {
                    do {
                        switch ConversionService.value {
                        case "USD" :
                            let welcomecourse = try JSONDecoder().decode(WelcomeCourseUSD.self, from: dataUnwrapped)
                            let valueOfChange = welcomecourse.rates.usd
                            /*
                            print(welcomecourse.success)
                            //print(welcomecourse)
                            print(welcomecourse.timestamp)
                            print(welcomecourse.base)
                            print(welcomecourse.date)
                            //   print(welcomecourse.rates.rub)
                            let result = "Le \(welcomecourse.date), 1 \(welcomecourse.base) vaut \(welcomecourse.rates.usd) \(ConversionService.value)"
                         //   let result2 = "et 1 \(ConversionService.value) vaut \(1/welcomecourse.rates.usd) \(welcomecourse.base)."
                            
                            print(result)
                           // infoBack(true,result,result2,valueOfChange)
                            */
                            infoBack(true,valueOfChange)
                        case "GBP" :
                            let welcomecourse = try JSONDecoder().decode(WelcomeCourseGBP.self, from: dataUnwrapped)
                            let valueOfChange = welcomecourse.rates.gbp
                            /*
                            print(welcomecourse.success)
                            //print(welcomecourse)
                            print(welcomecourse.timestamp)
                            print(welcomecourse.base)
                            print(welcomecourse.date)
                            //   print(welcomecourse.rates.rub)
                            let result = "Le \(welcomecourse.date), 1 \(welcomecourse.base) vaut \(welcomecourse.rates.gbp) \(ConversionService.value)"
                           // let result2 = "et 1 \(ConversionService.value) vaut \(1/welcomecourse.rates.gbp) \(welcomecourse.base)."
                            print(result)
                            //infoBack(true,result,result2,valueOfChange)
                            */
                            infoBack(true,valueOfChange)
                        case "RUB" :
                            let welcomecourse = try JSONDecoder().decode(WelcomeCourseRUB.self, from: dataUnwrapped)
                            let valueOfChange = welcomecourse.rates.rub
                            /*
                            print(welcomecourse.success)
                            //print(welcomecourse)
                            print(welcomecourse.timestamp)
                            print(welcomecourse.base)
                            print(welcomecourse.date)
                            //   print(welcomecourse.rates.rub)
                            let result = "Le \(welcomecourse.date), 1 \(welcomecourse.base) vaut \(welcomecourse.rates.rub) \(ConversionService.value)"
                           // let result2 = "et 1 \(ConversionService.value) vaut \(1/welcomecourse.rates.rub) \(welcomecourse.base)."
                            print(result)
                            //infoBack(true,result,result2,valueOfChange)
                            */
                            infoBack(true,valueOfChange)
                        default :
                            print("Erreur")
                            //infoBack(false,"Error","",0)
                            infoBack(false,0)
                        }
                    } catch {
                        print("Problème")
                        //infoBack(false,"Error","",0)
                        infoBack(false,0)
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
