//
//  Earthquake.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 24.02.2023.
//

import Foundation

struct Earthquake: Codable, Identifiable, Hashable {
    var id: String {
        eventID
    }
    var eventID: String
    var location: String
    var latitude: String
    var longitude: String
    var depth: String
    var type: String
    var magnitude: String
    var country: String?
    var province: String?
    var district: String?
    var date: String
    var formattedDate: Date {
        return Earthquake.dateFromISOString(string: date) ?? Date()
    }
    
    static func dateFromISOString(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"   
        return dateFormatter.date(from: string)
    }
    
}
