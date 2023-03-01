//
//  City.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 1.03.2023.
//

import Foundation
import MapKit

struct City: Identifiable {
    var id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

let sampleCity = City(name: "Test", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275))
