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
    
    private var task:URLSessionDataTask?
    
    func getTranslation(stringAdress: String, infoBack: @escaping (Result<TranslationReturned,APIErrors>)->Void) {
        
        guard let url = URL(string: stringAdress) else {
            infoBack(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    infoBack(.failure(.errorGenerated))
                    return
                }
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
                    infoBack(.success(translationDone))
                } catch {
                    infoBack(.failure(.badFile))
                }
            }
        }
        task?.resume()
    }
}
