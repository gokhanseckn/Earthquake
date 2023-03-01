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
        HStack(spacing: 10) {
            Text(String(format: "%.1f", Double(earthquake.magnitude) ?? "0"))
                .font(.headline)
                .padding()
                .background(earthquake.color)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                if  (earthquake.province != nil) && (earthquake.district != nil) {
                    VStack(alignment: .leading) {
                        Text(earthquake.province!)
                            .font(.headline)
                        Text(earthquake.district!)
                            .foregroundColor(.black.opacity(0.6))
                    }
                } else {
                    Text(earthquake.location)
                        .font(.headline)
                        .lineLimit(1)
                }
                
                HStack(spacing: 2) {
                    Text("\(earthquake.depth) km •")
                    Text("\(Earthquake.dateFormatter.string(from: earthquake.formattedDate)) •")
                    Text(Earthquake.relativeDateTimeFormatter.localizedString(for: earthquake.formattedDate, relativeTo: Date.now))
                }
                .font(.footnote)
                .foregroundColor(.secondary)
            }
        }
    }
}


struct EarthquakeRow_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeRow(earthquake: sampleEarthquake)
    }
}
