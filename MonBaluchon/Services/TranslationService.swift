//
//  TranslationService.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 20/05/2021.
//

import Foundation

class TranslationService {
    static var shared = TranslationService()
    private init() {}
    
    init(session:URLSession) {
        self.session = session
    }
    private var session = URLSession(configuration: .default)
    
    private let urlBase = "https://translation.googleapis.com/language/translate/v2?"
    private let authorization = "&key="
    private var code = Keys.translation
    private var askForWord = "q="
    private static var toTranslate = ""
    private var word = "\(toTranslate)"
    private var askForLanguage = "&target="
    private var format = "&format=html"
    
    private var task:URLSessionDataTask?
    
    func getTranslation(toLanguage:String, text: String,infoBack: @escaping (Result<TranslationReturned,APIErrors>)->Void) {
        
        guard toLanguage != "" else {
            print("pas de texte")
            return
        }
        
        word = text
        let stringAdress = urlBase + askForWord + word + askForLanguage + toLanguage + authorization + code.rawValue + format
        
        guard let url = URL(string: stringAdress) else {
            infoBack(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let dataUnwrapped = data else {
                    infoBack(.failure(.noData))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    infoBack(.failure(.invalidStatusCode))
                    return
                }
                do {
                    let translationDone = try JSONDecoder().decode(TranslationReturned.self, from: dataUnwrapped)
                    
                    //let wordTranslated = translationDone.data.translations[0] // À passer dans le contrôleur
                    infoBack(.success(translationDone))
                } catch {
                    print("Problème")
                    infoBack(.failure(.badFile))
                }
            }
        }
        task?.resume()
    }
}
