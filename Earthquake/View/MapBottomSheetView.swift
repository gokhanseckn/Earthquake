//
//  MapView.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 24.02.2023.
//

import SwiftUI
import MapKit

struct MapBottomSheetView: View {
    let cities: [City]
    
    var body: some View {
        Map(coordinateRegion:
                .constant(MKCoordinateRegion(
                    center: (cities.first?.coordinate)!,
                    span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
                ),
            annotationItems: cities
        ) { place in
            MapMarker(coordinate: place.coordinate)
        }
    }
}

struct MapBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapBottomSheetView(cities: [sampleCity])
    }
}
