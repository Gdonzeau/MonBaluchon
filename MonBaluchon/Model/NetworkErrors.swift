//
//  API_Errors.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 01/06/2021.
//

import Foundation

enum APIErrors: String, Error {
    case noContact
    case noData
    case badFile
    case chépasquoi
    case noError = "There is no error."
    case decodingError
    case invalidURL = "Not the right adress."
    case invalidStatusCode
    case errorGenerated
}
