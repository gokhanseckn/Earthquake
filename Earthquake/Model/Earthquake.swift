//
//  Earthquake.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 24.02.2023.
//

import Foundation
import SwiftUI

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
        return Calendar.current.date(byAdding: .hour, value: 3, to: Earthquake.dateFromISOString(string: date) ?? Date())!
    }
    var color: Color {
        switch Double(magnitude)! {
        case 6...:
            return .red
        case 5...:
            return .pink.opacity(0.5)
        case 3...:
            return .orange.opacity(0.5)
        case 1...:
            return .gray.opacity(0.3)
        default:
            return .gray.opacity(0.3)
        }
    }
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    static var relativeDateTimeFormatter : RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }
    
    static func dateFromISOString(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"   
        return dateFormatter.date(from: string)
    }
}

let sampleEarthquake: Earthquake = Earthquake(eventID: "1",
                                               location: "Test",
                                               latitude: "10",
                                               longitude: "10",
                                               depth: "10",
                                               type: "ML",
                                               magnitude: "1",
                                               province: "Kahramanmaras",
                                               district: "Ekinozu",
                                               date: "2023-02-28T13:22:02")

