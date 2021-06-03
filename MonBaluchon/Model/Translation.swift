//
//  Translation.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 20/05/2021.
//

import Foundation

struct TranslationReturned: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText, detectedSourceLanguage: String
}
