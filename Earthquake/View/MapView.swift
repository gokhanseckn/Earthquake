//
//  MapView.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 24.02.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    var latitude: Double
    var longitude: Double
    
    var body: some View {
        Map(coordinateRegion: .constant(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
            )
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(latitude: 38.2233, longitude: 38.7942)
    }
}
