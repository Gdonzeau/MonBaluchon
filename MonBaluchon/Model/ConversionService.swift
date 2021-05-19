//
//  QuoteService.swift
//  Appel_Reseau
//
//  Created by Guillaume Donzeau on 01/05/2021.
//

import Foundation

class ConversionService {
    
    //private static let quoteUrl = URL(string: "https://api.forismatic.com/api/1.0/")!
    //private static let quoteUrl = URL(string: "http://data.fixer.io/api/latest?&access_key=a7e3958d36cc451f0cfa1eb0c672a31a&symbols=EUR")!
    private static let urlBase = "http://data.fixer.io/api/latest?"
    private static let authorization = "&access_key="
    private static var code = "a7e3958d36cc451f0cfa1eb0c672a31a"
    private static var symbol = "&symbols="
    private static var value = "USD"
    private static var base = "&base="
    private static var valueBase = "EUR"// Don't change, restricted
    private static var final = "&callback=MY_FUNCTION"
    
    static func getConversion() {
        let url = URL(string: urlBase + authorization + code + symbol + value + base + valueBase + final)!
        print(url)
        
        //var request = URLRequest(url: quoteUrl)
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            print("1")
            
            //print(data)
            if let dataUnwrapped = data {
                if let result2 = String( data: dataUnwrapped , encoding: .utf8) {
                    print("Reçu : \(result2)")
                    //let cours:Conversion = try? JSONDecoder().decode([Any: Any].self, from: <#T##Data#>)
                }
                
                if let responseJSON = try? JSONDecoder().decode([String: Bool].self, from: dataUnwrapped) ,
                   let text = responseJSON["success"] { //,
                    //let author = responseJSON["rates"] {
                    print("réponse reçue")
                   // print(data)
                    print(responseJSON)
                    print(text)
                    //print(author)
                } else {
                    print("pas compris2")
                }
            }
            
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
        }
        task.resume()
        
        print("Demande")
    }
    
    
}
