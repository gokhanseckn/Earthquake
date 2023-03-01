//
//  EarthquakeViewModel.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 1.03.2023.
//

import Foundation

@MainActor
class EarthquakeViewModel: ObservableObject {
    
    @Published var earthquakes: [Earthquake] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    var filteredEarthquakes: [Earthquake] {
        if searchText.isEmpty {
            return earthquakes
        } else {
            return earthquakes.filter { earthquake in
                earthquake.location.contains(searchText)
            }
        }
    }
    
    func getLastEarthquakes(date: Date, mag: String) async {
        isLoading = true
        var formatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter
        }
        let endDate = date
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
                URLQueryItem(name: "minmag", value: mag)
            ]
            return components.url
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            earthquakes = try JSONDecoder().decode([Earthquake].self, from: data)
            isLoading = false
        } catch {
            print(String(describing: error))
            earthquakes = []
        }
    }
}
