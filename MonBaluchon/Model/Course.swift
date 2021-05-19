//
//  Quote.swift
//  Appel_Reseau
//
//  Created by Guillaume Donzeau on 06/05/2021.
//

import Foundation

struct Conversion: Codable {
    let success:Bool
    let timestamp:Int
    let base:String
    let date:String
    struct rates {
        let EUR:Int
    }
    
}
