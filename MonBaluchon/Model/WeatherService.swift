//
//  WeatherService.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 18/05/2021.
//

import Foundation

class WeatherService {
    
    //private static let quoteUrl = URL(string: "https://api.forismatic.com/api/1.0/")!
    //private static let quoteUrl = URL(string: "http://data.fixer.io/api/latest?&access_key=a7e3958d36cc451f0cfa1eb0c672a31a&symbols=EUR")!
    private static let urlBase = "api.openweathermap.org/data/2.5/weather?"
    private static let authorization = "&appid="
    private static var code = "4fbc06f6ef2234b97dcf057bc1f96928"
    private static var place = "q="
    private static var city = "Paris"
    
    static func getWeather() {
        let url = URL(string: "http://data.fixer.io/api/latest?" + "\(place)" + "\(city)" + "\(authorization)" + "\(code)")!
        print(url)
        
        //var request = URLRequest(url: quoteUrl)
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            print("1")
            print(data)
            DispatchQueue.main.async {
                print("2")
            if let data = data, error == nil {
                print("3")
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        print("4")
                        if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                           let text = responseJSON["id"] { //,
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
