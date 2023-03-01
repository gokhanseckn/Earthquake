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
        VStack {
            MapView(cities:[City(
                name: earthquake.province ?? "",
                coordinate: CLLocationCoordinate2D(
                    latitude: Double(earthquake.latitude)!,
                    longitude: Double(earthquake.longitude)!))]
            )
            .frame(height: 400)
            .padding(.top, 20)
            
            Text(earthquake.location)
            Spacer()
        }
    }
}

struct EarthquakeBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeBottomSheetView(earthquake: sampleEarthquake)
    }
}
