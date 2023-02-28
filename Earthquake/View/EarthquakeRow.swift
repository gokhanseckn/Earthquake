//
//  EarthquakeRow.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 24.02.2023.
//

import SwiftUI

struct EarthquakeRow: View {
    
    var earthquake: Earthquake
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var relativeDateTimeFormatter : RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 30) {
            Text(String(format: "%.1f", Double(earthquake.magnitude) ?? "0"))
                .font(.headline)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width: 50, height: 40)
                        .opacity(0.4)
                )
            VStack(alignment: .leading) {
                Text("\(earthquake.province ?? "") - \(earthquake.district ?? "")")
                    .font(.headline)
                HStack {
                    Text("\(earthquake.depth) km")
                    Text(dateFormatter.string(from: earthquake.formattedDate))
                    Text(relativeDateTimeFormatter.localizedString(for: earthquake.formattedDate, relativeTo: Date.now))
                }
            }
        }
    }
}


struct EarthquakeRow_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeRow(earthquake:Earthquake(
            eventID: "1",
            location: "Test",
            latitude: "10",
            longitude: "10",
            depth: "10",
            type: "ML",
            magnitude: "3.9",
            province: "Kahramanmaras",
            district: "Ekinozu",
            date: "2023-02-28T13:22:02"
        )
        )
    }
}
