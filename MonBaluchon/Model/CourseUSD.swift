//
//  CourseBis.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 20/05/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcomecourse = try? newJSONDecoder().decode(WelcomeCourse.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct WelcomeCourseUSD: Codable {
    var success: Bool
    var timestamp: Int
    var base, date: String
    var rates: RatesUSD
}

// MARK: - Rates

struct RatesUSD: Codable {
   // var rub: Double
    var usd: Double
    

    enum CodingKeys: String, CodingKey {
       // case rub = "RUB"
        case usd = "USD"
    }
    
}
