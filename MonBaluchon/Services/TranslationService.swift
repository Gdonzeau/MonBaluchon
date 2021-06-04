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
    
    private var session = URLSession(configuration: .default)
    
    init(session:URLSession) {
        self.session = session
    }
    
    private static let urlBase = "https://translation.googleapis.com/language/translate/v2?"
    private static let authorization = "&key="
    private static var code = Keys.translation
    private static var askForWord = "q="
    private static var toTranslate = ""
    private static var word = "\(toTranslate)"
    private static var askForLanguage = "&target="
    private static var format = "&format=html"
    
    private var task:URLSessionDataTask?
    
    func getTranslation(toLanguage:String, text: String,infoBack: @escaping (Result<String,APIErrors>)->Void) {
        
        guard toLanguage != "" else {
            print("pas de texte")
            return
        }
        
        TranslationService.word = text
        let stringAdress = TranslationService.urlBase + TranslationService.askForWord + TranslationService.word + TranslationService.askForLanguage + toLanguage + TranslationService.authorization + TranslationService.code.rawValue + TranslationService.format
        
        guard let url = URL(string: stringAdress) else {
            print("Bad URL")
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
                    infoBack(.failure(.noContact))
                    return
                }
                
                do {
                    let translationDone = try JSONDecoder().decode(TranslationReturned.self, from: dataUnwrapped)
                    
                    let wordTranslated = translationDone.data.translations[0]
                    infoBack(.success(wordTranslated.translatedText))
                } catch {
                    print("Problème")
                    infoBack(.failure(.badFile))
                }
            }
        }
        task?.resume()
    }
}
