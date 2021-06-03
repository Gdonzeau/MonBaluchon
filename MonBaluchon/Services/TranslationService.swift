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
    private static var language = "ru"// Don't change, restricted
    private static var final = "&callback=MY_FUNCTION"
    private static var format = "&format=html"
    
    private var task:URLSessionDataTask?
    
    func getTranslation(toLanguage:String, text: String,infoBack: @escaping (Result<String,APIErrors>)->Void) {
        
        guard toLanguage != "" else {
            print("pas de texte")
            return
        }

        TranslationService.word = text
        let stringAdress = TranslationService.urlBase + TranslationService.askForWord + TranslationService.word + TranslationService.askForLanguage + toLanguage + TranslationService.authorization + TranslationService.code.rawValue + TranslationService.format

        let url = URL(string: stringAdress)!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
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
                        let welcometranslation = try JSONDecoder().decode(TranslationReturned.self, from: dataUnwrapped)
                        let wordTranslated = welcometranslation.data.translations[0]
                        print(wordTranslated.translatedText)
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
