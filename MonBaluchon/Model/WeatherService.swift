//
//  WeatherService.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 18/05/2021.
//

import Foundation

class WeatherService {
    static var shared = WeatherService()
    private init() {}
    
    //private static let quoteUrl = URL(string: "https://api.forismatic.com/api/1.0/")!
    private static let pictureURL = URL(string: "http://openweathermap.org/img/w/10d.png")!
    
    private static let urlBase2 = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Paris&appid=4fbc06f6ef2234b97dcf057bc1f96928")!
    private static let urlBase = "http://api.openweathermap.org/data/2.5/weather?"
    private static let authorization = "&appid="
    private static var code = "4fbc06f6ef2234b97dcf057bc1f96928"
    private static var place = "q="
    private static var city = "Paris"
    
    private var task:URLSessionDataTask?
    
    func getWeather(town:String,infoBack: @escaping (Bool,[Any?])-> Void) {
        WeatherService.city = town
        let url = URL(string: WeatherService.urlBase + WeatherService.place + WeatherService.city + WeatherService.authorization + WeatherService.code)!
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let dataUnwrapped = data {
                    do {
                        let welcomeweather = try JSONDecoder().decode(WelcomeWeather.self, from: dataUnwrapped)
                        print(welcomeweather)
                        let iconUrl = URL(string:"http://openweathermap.org/img/w/\(welcomeweather.weather[0].icon).png")!
                        let weatherInTown = [welcomeweather.coord.lon, //0
                                             welcomeweather.coord.lat,
                                             welcomeweather.wind.speed,
                                             welcomeweather.wind.deg,
                                             welcomeweather.name,
                                             welcomeweather.main.temp,//5
                                             welcomeweather.main.feelsLike,
                                             welcomeweather.main.tempMin,
                                             welcomeweather.main.humidity,
                                             welcomeweather.main.tempMax,
                                             welcomeweather.main.pressure,//10
                                             welcomeweather.main.humidity,
                                             welcomeweather.weather,
                                             welcomeweather.weather[0].weatherDescription,
                                             welcomeweather.weather[0].main,
                                             welcomeweather.weather[0].icon,//15
                                             welcomeweather.weather[0].id,
                                             iconUrl] as [Any]
                        print (weatherInTown)
                        infoBack(true,weatherInTown)
                    } catch {
                        print("Problème")
                      //  infoBack(false,weatherInTown) // Gérer le cas d'erreur
                    }
                }
            }
        }
        task?.resume()
    }
}
