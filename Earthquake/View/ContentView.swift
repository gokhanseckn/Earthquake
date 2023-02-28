//
//  ContentView.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 21.02.2023.
//

import SwiftUI
import MapKit

struct BottomSheetView: View {
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

struct ContentView: View {
    
    @State private var earthquakes = [Earthquake]()
    @State private var isPresented: Bool = false
    @State private var selectedEarthquake: Earthquake? = nil
    @State private var searchText: String = ""
    var searchResults: [Earthquake] {
        if searchText.isEmpty {
            return earthquakes
        } else {
            return earthquakes.filter { earthquake in
                earthquake.location.contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(searchResults, id: \.self) { earthquake in
                Button {
                    self.selectedEarthquake = earthquake
                } label: {
                    EarthquakeRow(earthquake: earthquake)
                }
                .buttonStyle(.plain)
            }
            .searchable(text: $searchText)
            .sheet(item: self.$selectedEarthquake) { earthquake in
                BottomSheetView(earthquake: earthquake)
                    .presentationDetents([.fraction(0.7)])
                    .presentationDragIndicator(.visible)
            }.task {
                await getLastEarthquakes()
            }
            .navigationTitle("Earthquakes in Turkey")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    func getLastEarthquakes() async {
        var formatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter
        }
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
        
        var url: URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "deprem.afad.gov.tr"
            components.path = "/apiv2/event/filter"
            components.queryItems = [
                URLQueryItem(name: "start", value: formatter.string(from: startDate)),
                URLQueryItem(name: "end", value: formatter.string(from: endDate)),
                URLQueryItem(name: "orderby", value: "timedesc")
            ]
            return components.url
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            earthquakes = try JSONDecoder().decode([Earthquake].self, from: data)
        } catch {
            print(String(describing: error))
            earthquakes = []
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
