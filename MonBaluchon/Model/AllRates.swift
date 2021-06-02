//
//  CourseAll.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 21/05/2021.
//

import Foundation

struct RatesOnLine: Codable {
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: [String: Double]
}
