//
//  Weather.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 19/05/2021.
//

import Foundation

struct Weather:Decodable {
    struct coord {
        var lon:Double
        var lat:Double
    }
    struct weather {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
    
    var base:String
    struct main {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Int
        var humidity: Int
    }
    var visibility: Int
    struct wind {
        var speed: Double
        var deg: Int
        var gust: Double
    }
    struct clouds {
        var all: Int
    }
    var dt:Int
    struct sys {
        var type: Int
        var id: Int
        var country: String
        var sunrise: Int
        var sunset: Int
    }
    var timezone: Int
    var id: Int
    var name: String
    var cod: Int
}

