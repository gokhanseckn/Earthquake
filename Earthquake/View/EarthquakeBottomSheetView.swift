//
//  EarthquakeBottomSheetView.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 1.03.2023.
//

import SwiftUI
import MapKit

struct EarthquakeBottomSheetView: View {
    var earthquake: Earthquake
    
    var body: some View {
        ZStack {
            MapView(cities:[City(
                name: earthquake.province ?? "",
                coordinate: CLLocationCoordinate2D(
                    latitude: Double(earthquake.latitude)!,
                    longitude: Double(earthquake.longitude)!))]
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    Text(String(format: "%.1f", Double(earthquake.magnitude) ?? "0"))
                        .font(.headline)
                        .padding()
                        .background(earthquake.color)
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text(earthquake.province ?? earthquake.location)
                            .font(.headline)
                        Text(earthquake.district ?? "")
                            .foregroundColor(.black.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        HStack {
                            Text("\(earthquake.depth) km")
                            Text("•")
                            Text("\(Earthquake.dateFormatter.string(from: earthquake.formattedDate))")
                        }
                        Text(Earthquake.relativeDateTimeFormatter.localizedString(for: earthquake.formattedDate, relativeTo: Date.now))
                    }
                    .font(.footnote)
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThickMaterial)
                )
                .padding()
            }
            
            
        }
    }
}

struct EarthquakeBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeBottomSheetView(earthquake: sampleEarthquake)
    }
}
