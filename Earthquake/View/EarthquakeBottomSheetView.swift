//
//  EarthquakeBottomSheetView.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 1.03.2023.
//

import SwiftUI
import MapKit

struct EarthquakeBottomSheetView: View {
    @Environment(\.dismiss) var dismiss
    var earthquake: Earthquake
    
    var body: some View {
        ZStack {
            MapBottomSheetView(cities:[City(
                name: earthquake.province ?? "",
                coordinate: CLLocationCoordinate2D(
                    latitude: Double(earthquake.latitude)!,
                    longitude: Double(earthquake.longitude)!))]
            )
            .ignoresSafeArea()
            
            VStack {
                backArrow
                    .padding(.horizontal)
                Spacer()
                cardView
                    .padding()
                    .cardBackground()
                    .padding()
            }
        }
    }
    
    var backArrow: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.backward")
            }
            .buttonStyle(.plain)
            .padding()
            .cardBackground()
            
            Spacer()
        }
    }
    
    var cardView: some View {
        HStack {
            Text(String(format: "%.1f", Double(earthquake.magnitude) ?? "0"))
                .magnitudeCard(color: earthquake.color)
            
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
    }
}

struct EarthquakeBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeBottomSheetView(earthquake: sampleEarthquake)
    }
}
