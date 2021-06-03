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
    
    private static let pictureURL = URL(string: "http://openweathermap.org/img/w/10d.png")!
    
    private static let urlBase2 = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Paris&appid=4fbc06f6ef2234b97dcf057bc1f96928")!
    private static let urlBase = "http://api.openweathermap.org/data/2.5/weather?"
    private static let authorization = "&appid="
    private static var code = Keys.weather
    private static var place = "q="
    private static var city = "Paris"
    
    private var task:URLSessionDataTask?
    
    func getWeather(town:String,infoBack: @escaping ((Result<[String?],APIErrors>)->Void)) {
        
        WeatherService.city = town
        
        let url = URL(string: WeatherService.urlBase + WeatherService.place + WeatherService.city + WeatherService.authorization + WeatherService.code.rawValue)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    infoBack(.failure(.noContact))
                    return
                }
                guard let dataUnwrapped = data else {
                    infoBack(.failure(.noData))
                    return
                }
                    do {
                        let welcomeweather = try JSONDecoder().decode(WeatherReturned.self, from: dataUnwrapped)
                        print(welcomeweather)
                        let iconUrl = "http://openweathermap.org/img/w/\(welcomeweather.weather[0].icon).png"
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
                        
                        
                        let messageBack = [self.buildStringAnswer(result: weatherInTown),iconUrl] as [String?]
                        infoBack(.success(messageBack))
                    } catch {
                        print("Problème")
                      //  infoBack(false,weatherInTown) // Gérer le cas d'erreur
                    }
                
            }
        }
        task?.resume()
    }
    func buildStringAnswer(result: [Any])-> String {
         let lon = result[0]
        let lat = result[1]
        let windSpeed = result[2]
        let windDeg = result[3]
        let townName = result[4]
        let temperature = result[5]
        let ressenti = result[6]
        let temperatureMin = result[7]
        let temperatureMax = result[9]
        let pression = result[10]
        let humidity = result[8]
        //let iconUrl = result[17]
        let descriptionWeather = "À \(townName), de lat: \(lat) et de long: \(lon), le vent vient du \(windDeg), avec une vitesse de \(windSpeed) m/s soit \(Int(windSpeed as! Double*3.6)) km/h. La température est de \(Int(temperature as! Double - 273.5)) avec une T.min de \(Int(temperatureMin as! Double - 273.5)) et une T.max de \(Int(temperatureMax as! Double - 273.5)) et une température ressentie de \(Int(ressenti as! Double - 273.5)). La pression est de \(pression) ha. L'humidité est de \(humidity)."
        
        return descriptionWeather
    }
}
