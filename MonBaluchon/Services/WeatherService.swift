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
    
    private var session = URLSession(configuration: .default)
    
    init(session:URLSession) {
        self.session = session
    }
    
    private let urlBase = "http://api.openweathermap.org/data/2.5/weather?"
    private let authorization = "&appid="
    private var code = Keys.weather
    private var place = "q="
    private var city = "Paris"
    private var andUnits = "&units="
    private var metric = "metric"
    
    private var task:URLSessionDataTask?

    func getWeather(town:String,infoBack: @escaping ((Result<WeatherReturned,APIErrors>)->Void)) {
        guard let httpTown = town.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        let stringAdress = urlBase + place + httpTown + authorization + code.rawValue + andUnits + metric
        
        guard let url = URL(string: stringAdress) else {
            infoBack(.failure(.invalidURL))
            return
        }
        
        let request = createConversionRequest(url:url)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    infoBack(.failure(.invalidStatusCode))
                    return
                }
                guard let dataUnwrapped = data else {
                    infoBack(.failure(.noData))
                    return
                }
                do {
                    let weatherReceived = try JSONDecoder().decode(WeatherReturned.self, from: dataUnwrapped)
                    infoBack(.success(weatherReceived))
                } catch {
                    infoBack(.failure(.chépasquoi))
                    return
                }
                
            }
        }
        task?.resume()
    }
    func createConversionRequest(url:URL) -> URLRequest {
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
}
