//
//  EarthquakeRow.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 24.02.2023.
//

import SwiftUI

struct EarthquakeRow: View {
    
    var earthquake: Earthquake
    
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
                }
            }
        }
    }
}


struct EarthquakeRow_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeRow(earthquake:
                        Earthquake(
                            eventID: "1",
                            location: "Test",
                            latitude: "10",
                            longitude: "10",
                            depth: "10",
                            type: "ML",
                            magnitude: "5",
                            country: "Test",
                            province: "Test",
                            district: "Test",
                            date: "2023-02-24"
                        )
        )
    }
}
