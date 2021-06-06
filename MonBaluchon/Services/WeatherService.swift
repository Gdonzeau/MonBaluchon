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
    
    private static let urlBase = "http://api.openweathermap.org/data/2.5/weather?"
    private static let authorization = "&appid="
    private static var code = Keys.weather
    private static var place = "q="
    private static var city = "Paris"
    private static var andUnits = "&units="
    private static var metric = "metric"
    
    private var task:URLSessionDataTask?
    
    func getWeather(town:String,infoBack: @escaping ((Result<[String?],APIErrors>)->Void)) {
        
        guard let httpTown = town.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        print (httpTown)
        //WeatherService.city = httpTown
        
        //var adressSent:String = ""
        let stringAdress = WeatherService.urlBase + WeatherService.place + httpTown + WeatherService.authorization + WeatherService.code.rawValue + WeatherService.andUnits + WeatherService.metric
        
        print (stringAdress)
        guard let url = URL(string: stringAdress) else {
            print("Bad URL")
            return
        }
        
        let request = createConversionRequest(url:url)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    infoBack(.failure(.noContact))
                    return
                }
                print("réponse : \(response)")
                guard let dataUnwrapped = data else {
                    infoBack(.failure(.noData))
                    return
                }
                print("data :\(dataUnwrapped)")
                do {
                    let str = String(decoding: dataUnwrapped, as: UTF8.self)
                    print("str01 : \(str)")
                    let weatherReceived = try JSONDecoder().decode(WeatherReturned.self, from: dataUnwrapped)
                    print(weatherReceived)
                    let iconUrl = "http://openweathermap.org/img/w/\(weatherReceived.weather[0].icon).png"
                    let weatherInTown = [weatherReceived.coord.lon, //0
                                         weatherReceived.coord.lat,
                                         weatherReceived.wind.speed,
                                         weatherReceived.wind.deg,
                                         weatherReceived.name,
                                         weatherReceived.main.temp,//5
                                         weatherReceived.main.feelsLike,
                                         weatherReceived.main.tempMin,
                                         weatherReceived.main.humidity,
                                         weatherReceived.main.tempMax,
                                         weatherReceived.main.pressure,//10
                                         weatherReceived.main.humidity,
                                         weatherReceived.weather,
                                         weatherReceived.weather[0].weatherDescription,
                                         weatherReceived.weather[0].main,
                                         weatherReceived.weather[0].icon,//15
                                         weatherReceived.weather[0].id,
                                         iconUrl] as [Any]
                    print ("temps : \(weatherInTown)")
                    
                    let messageBack = [self.buildStringAnswer(result: weatherInTown),iconUrl] as [String?]
                    infoBack(.success(messageBack))
                } catch {
                    let str = String(decoding: dataUnwrapped, as: UTF8.self)
                    print("str02 : \(str)")
                    print("Problème")
                    return
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
        let description = result[13]
        let humidity = result[8]
        //let iconUrl = result[17]
        let descriptionWeather = "À \(townName), de lat: \(lat) et de long: \(lon), le vent vient du \(windDeg), avec une vitesse de \(windSpeed) m/s soit \(Int(windSpeed as! Double*3.6)) km/h. La température est de \(Int(temperature as! Double)) degré(s) avec une T.min de \(Int(temperatureMin as! Double)) degré(s), une T.max de \(Int(temperatureMax as! Double)) degrés et une température ressentie de \(Int(ressenti as! Double)) degrés. La pression est de \(pression) ha. L'humidité est de \(humidity)%."
        print(descriptionWeather) // to avoid yellow triangle :)
        let descriptionWeatherSimple = "\(townName), \n température : \n \(Int(temperature as! Double)) degrés \n et le temps est \n \(description)"
        
        return descriptionWeatherSimple
    }
    func createConversionRequest(url:URL) -> URLRequest {
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
}
