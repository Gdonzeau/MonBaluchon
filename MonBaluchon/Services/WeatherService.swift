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
    
    init(session:URLSession) {
        self.session = session
    }
    
    private var session = URLSession(configuration: .default)
    
    private var task:URLSessionDataTask?

    func getWeather(stringAdress:String, infoBack: @escaping ((Result<WeatherReturned,APIErrors>)->Void)) {
        
        guard let url = URL(string: stringAdress) else {
            infoBack(.failure(.invalidURL))
            return
        }
        
        let request = createConversionRequest(url:url)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    infoBack(.failure(.errorGenerated))
                    return
                }
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
                    infoBack(.failure(.badFile))
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
