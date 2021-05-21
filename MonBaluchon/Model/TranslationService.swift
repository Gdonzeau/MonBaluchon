//
//  TranslationService.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 20/05/2021.
//

import Foundation

class TranslationService {
    
    
    
    private static let urlBase = "https://translation.googleapis.com/language/translate/v2?"
    private static let authorization = "&key="
    private static var code = "AIzaSyAyMBiADbjYBlaB7eHcYHYxfg_qJbR4Hjo"
    private static var askForWord = "q="
    private static var toTranslate = "Bonjour"
    private static var word = "\(toTranslate)"
    private static var askForLanguage = "&target="
    private static var language = "ru"// Don't change, restricted
    private static var final = "&callback=MY_FUNCTION"
    
    static func getTranslation(text: String,infoBack: @escaping (Bool,String?)->Void) {
        
        word = text
        let stringAdress = urlBase + askForWord + word + askForLanguage + language + authorization + code
        print(stringAdress)
        let url = URL(string: stringAdress)!
        print(url)
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
     //  let body = ""
     //   request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            print("1")
            DispatchQueue.main.async {
            //print(data)
            if let dataUnwrapped = data {
                /*
                if let result2 = String( data: dataUnwrapped , encoding: .utf8) {
                  //  print("Reçu : \(result2)")
                    let json = """
                    \(result2)
                    """.data(using: .utf8)!
                   // print(String( data: json , encoding: .utf8) ?? "Rien")
                }
                */
                    do {
                    let welcomecourse = try JSONDecoder().decode(WelcomeTranslation.self, from: dataUnwrapped)
                        let wordTranslated = welcomecourse.data.translations[0]
                        print(wordTranslated.translatedText)
                        infoBack(true,wordTranslated.translatedText)
                    } catch {
                        print("Problème")
                        infoBack(true,"Error")
                    }
            }
            }
            /*
            DispatchQueue.main.async {
                print("2")
            if let data = data, error == nil {
                print("3")
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        print("4")
                        if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                           let text = responseJSON["date"] { //,
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
            */
        }
        task.resume()
        
        print("Demande")
    }
    
    
}
