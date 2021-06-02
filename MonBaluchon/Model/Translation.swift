//
//  Translation.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 20/05/2021.
//

import Foundation

// MARK: - Welcome
struct TranslationReturned: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText, detectedSourceLanguage: String
}
