//
//  CurrentDay.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 07/06/2021.
//

import Foundation

class CurrentDay {
    //static var today = CurrentDate(year: 0, month: 0, day: 0)
    
    static var lastDateUsed:String {
        get {
            return "\(day)-\(month)-\(year)"
        }
        set {
            
        }
    }
    
    static var year:String {
        get {
            return UserDefaults.standard.string(forKey: Keys.currentYear) ?? "1984"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.currentYear)
        }
    }
    static var month:String {
        get {
            return UserDefaults.standard.string(forKey: Keys.currentMonth) ?? "1"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.currentMonth)
        }
    }
    static var day:String {
        get {
            return UserDefaults.standard.string(forKey: Keys.currentDay) ?? "1"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.currentDay)
        }
    }
    
    private struct Keys {
        static let currentYear = "currentYear"
        static let currentMonth = "currentMonth"
        static let currentDay = "currentDay"
    }
}
