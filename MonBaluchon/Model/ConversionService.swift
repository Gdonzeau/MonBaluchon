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
    
    private static let urlBase = "http://data.fixer.io/api/latest?"
    private static let authorization = "&access_key="
    private static var code = "a7e3958d36cc451f0cfa1eb0c672a31a"
    private static var symbol = "&symbols="
    private static var value = "RUB"
    private static var base = "&base="
    private static var valueBase = "EUR"// Don't change, restricted
    private static var final = "&callback=MY_FUNCTION"
    static var dicoDevises = ["USD":"usd","RUB":"rub"]
    
    func getConversion(currencyName:String,infoBack: @escaping (Bool,String?,String?)->Void) {
        ConversionService.value = currencyName
        let url = URL(string: ConversionService.urlBase + ConversionService.authorization + ConversionService.code + ConversionService.symbol + ConversionService.value)! // + base + valueBase)! // + final)!
        //print(url)
        
        //var request = URLRequest(url: quoteUrl)
        var request = URLRequest(url:url)
        //let decoder = JSONDecoder()
        
        // let reponse = try? ServerResponse(from: ServerResponse.self as! Decoder)
        request.httpMethod = "POST"
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let dataUnwrapped = data {
                    if let result2 = String( data: dataUnwrapped , encoding: .utf8) {
                        print("Reçu : \(result2)") // To delete ?
                        let json = """
                    \(result2)
                    """.data(using: .utf8)!
                        print(String( data: json , encoding: .utf8) ?? "Rien")
                    }
                    // end of to delete ?
                    do {
                        switch ConversionService.value {
                        case "USD" :
                            let welcomecourse = try JSONDecoder().decode(WelcomeCourseUSD.self, from: dataUnwrapped)
                            print(welcomecourse.success)
                            //print(welcomecourse)
                            print(welcomecourse.timestamp)
                            print(welcomecourse.base)
                            print(welcomecourse.date)
                            //   print(welcomecourse.rates.rub)
                            let result = "Le \(welcomecourse.date), 1 \(welcomecourse.base) vaut \(welcomecourse.rates.usd) \(ConversionService.value)"
                            let result2 = "et 1 \(ConversionService.value) vaut \(1/welcomecourse.rates.usd) \(welcomecourse.base)."
                            print(result)
                            infoBack(true,result,result2)
                        case "GBP" :
                            let welcomecourse = try JSONDecoder().decode(WelcomeCourseGBP.self, from: dataUnwrapped)
                            print(welcomecourse.success)
                            //print(welcomecourse)
                            print(welcomecourse.timestamp)
                            print(welcomecourse.base)
                            print(welcomecourse.date)
                            //   print(welcomecourse.rates.rub)
                            let result = "Le \(welcomecourse.date), 1 \(welcomecourse.base) vaut \(welcomecourse.rates.gbp) \(ConversionService.value)"
                            let result2 = "et 1 \(ConversionService.value) vaut \(1/welcomecourse.rates.gbp) \(welcomecourse.base)."
                            print(result)
                            infoBack(true,result,result2)
                        case "RUB" :
                            let welcomecourse = try JSONDecoder().decode(WelcomeCourseRUB.self, from: dataUnwrapped)
                            print(welcomecourse.success)
                            //print(welcomecourse)
                            print(welcomecourse.timestamp)
                            print(welcomecourse.base)
                            print(welcomecourse.date)
                            //   print(welcomecourse.rates.rub)
                            let result = "Le \(welcomecourse.date), 1 \(welcomecourse.base) vaut \(welcomecourse.rates.rub) \(ConversionService.value)"
                            let result2 = "et 1 \(ConversionService.value) vaut \(1/welcomecourse.rates.rub) \(welcomecourse.base)."
                            print(result)
                            infoBack(true,result,result2)
                        default :
                            print("Erreur")
                            infoBack(false,"Error","")
                        }
                    } catch {
                        print("Problème")
                        infoBack(false,"Error","")
                    }
                }
            }
            /*
             DispatchQueue.main.async {
             print("2")
             if let data = data, error == nil {
             print("3")
             if let response = response as? HTTPURLResponse, response.statusCode == 200 {
             print("4")
             if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
             let text = responseJSON["date"] { //,
             //let author = responseJSON["rates"] {
             print("réponse reçue")
             print(data)
             print(text)
             //print(author)
             } else {
             print("pas compris")
             }
             }
             }
             }
             */
        }
        task.resume()
        
        print("Demande")
    }
    
    
}
