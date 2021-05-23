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
    
    private static let urlBase = "https://translation.googleapis.com/language/translate/v2?"
    private static let authorization = "&key="
    private static var code = "AIzaSyAyMBiADbjYBlaB7eHcYHYxfg_qJbR4Hjo"
    private static var askForWord = "q="
    private static var toTranslate = ""
    private static var word = "\(toTranslate)"
    private static var askForLanguage = "&target="
    private static var language = "ru"// Don't change, restricted
    private static var final = "&callback=MY_FUNCTION"
    
    private var task:URLSessionDataTask?
    
    func getTranslation(toLanguage:String, text: String,infoBack: @escaping (Bool,String?)->Void) {
        guard toLanguage != "" else {
            print("pas de texte")
            return
        }

        TranslationService.word = text
        let stringAdress = TranslationService.urlBase + TranslationService.askForWord + TranslationService.word + TranslationService.askForLanguage + toLanguage + TranslationService.authorization + TranslationService.code
        print(stringAdress)
        let url = URL(string: stringAdress)!
        print(url)
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let dataUnwrapped = data {
                    do {
                        let welcometranslation = try JSONDecoder().decode(WelcomeTranslation.self, from: dataUnwrapped)
                        let wordTranslated = welcometranslation.data.translations[0]
                        print(wordTranslated.translatedText)
                        infoBack(true,wordTranslated.translatedText)
                    } catch {
                        print("Problème")
                        infoBack(true,"Error")
                    }
                }
            }
        }
        task?.resume()
    }
}
