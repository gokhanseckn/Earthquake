//
//  EarthquakeViewModel.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 1.03.2023.
//

import Foundation
import MapKit
import SwiftUI

@MainActor
class EarthquakeViewModel: ObservableObject {
    
    @Published var earthquakes: [Earthquake] = []
    @Published var cities: [City] = []
    @Published var currentEarthquake: Earthquake = sampleEarthquake
    @Published var mapRegion: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var selectedDate: Date = Date()
    @Published var selectedMag: String = "3"
    
    let turkeyLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 38.9637, longitude: 35.2433)
    
    var filteredEarthquakes: [Earthquake] {
        if searchText.isEmpty {
            return earthquakes
        } else {
            return earthquakes.filter { earthquake in
                earthquake.location.contains(searchText)
            }
        }
    }
    
    func updateMapRegion(location: CLLocationCoordinate2D) {
        withAnimation(.easeOut) {
            mapRegion = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
    func nextButtonPressed() {
        guard let currentIndex = earthquakes.firstIndex(where: { e in Double(e.latitude) == mapRegion.latitude && Double(e.longitude) == mapRegion.longitude }) else {
            print("Should never happen")
            return
        }
        let nextIndex = currentIndex + 1
        guard earthquakes.indices.contains(nextIndex) else {
            // next index is not valid
            guard let firstLocation = earthquakes.first else { return }
            currentEarthquake = firstLocation
            updateMapRegion(location: CLLocationCoordinate2D(
                latitude: Double(firstLocation.latitude)!,
                longitude: Double(firstLocation.longitude)!
            ))
            return
        }
        // next is valid
        let nextLocation = earthquakes[nextIndex]
        currentEarthquake = nextLocation
        updateMapRegion(location: CLLocationCoordinate2D(
            latitude: Double(nextLocation.latitude)!,
            longitude: Double(nextLocation.longitude)!
        ))
    }
    
    func getLastEarthquakes() async {
        var formatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter
        }
        isLoading = true
        let endDate = selectedDate
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
        
        var url: URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "deprem.afad.gov.tr"
            components.path = "/apiv2/event/filter"
            components.queryItems = [
                URLQueryItem(name: "start", value: formatter.string(from: startDate)),
                URLQueryItem(name: "end", value: formatter.string(from: endDate)),
                URLQueryItem(name: "orderby", value: "timedesc"),
                URLQueryItem(name: "minmag", value: selectedMag),
                URLQueryItem(name: "limit", value: "50")
            ]
            return components.url
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            earthquakes = try JSONDecoder().decode([Earthquake].self, from: data)
            cities = []
            earthquakes.forEach({ earthquake in
                cities.append(City(name: earthquake.province ?? earthquake.location, coordinate: CLLocationCoordinate2D(
                    latitude: Double(earthquake.latitude)!,
                    longitude: Double(earthquake.longitude)!
                )))
            })
            updateMapRegion(location: CLLocationCoordinate2D(
                latitude: Double(earthquakes.first?.latitude ?? "\(turkeyLocation.latitude)")!,
                longitude: Double(earthquakes.first?.longitude ?? "\(turkeyLocation.longitude)")!
            ))
            currentEarthquake = earthquakes.first ?? sampleEarthquake
            isLoading = false
        } catch {
            print(String(describing: error))
            earthquakes = []
        }
    }
}
