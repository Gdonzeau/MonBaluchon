//
//  File.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 20/05/2021.
//

import Foundation

// MARK: - Welcome
struct WelcomeCourseRUB: Codable {
    var success: Bool
    var timestamp: Int
    var base, date: String
    var rates: RatesRUB
}

// MARK: - Rates

struct RatesRUB: Codable {
    var rub: Double
   // var usd: Double
    

    enum CodingKeys: String, CodingKey {
       case rub = "RUB"
        //case usd = "USD"
    }
    
}
