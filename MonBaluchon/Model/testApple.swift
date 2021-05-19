//
//  testApple.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 19/05/2021.
//

import Foundation

struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}

class testApple {
    
private static let json = """
{
    "name": "Durian",
    "points": 600,
    "description": "A fruit with a distinctive scent."
}
""".data(using: .utf8)!

    static func getApple() {
let decoder = JSONDecoder()
        if let product = try? decoder.decode(GroceryProduct.self, from: json) {
            print(product.name) // Prints "Durian"
        }
    }
}
