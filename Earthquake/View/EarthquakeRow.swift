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
    
    var color: Color {
        switch Double(earthquake.magnitude)! {
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
    
    var body: some View {
        HStack(spacing: 10) {
            Text(String(format: "%.1f", Double(earthquake.magnitude) ?? "0"))
                .font(.headline)
                .padding()
                .background(color)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                if  (earthquake.province != nil) && (earthquake.district != nil) {
                    VStack(alignment: .leading) {
                        Text(earthquake.province!)
                            .font(.headline)
                        Text(earthquake.district!)
                    }
                } else {
                    Text(earthquake.location)
                        .font(.headline)
                }
                
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
            magnitude: "1",
            province: "Kahramanmaras",
            district: "Ekinozu",
            date: "2023-02-28T13:22:02"
        )
        )
    }
}
