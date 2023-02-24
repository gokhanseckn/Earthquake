//
//  ContentView.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 21.02.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var earthquakes = [Earthquake]()
    @State private var isPresented: Bool = false
    @State private var selectedEarthquake: Earthquake? = nil
    
    var body: some View {
        NavigationView {
            List(earthquakes, id: \.self) { earthquake in
                Button {
                    self.selectedEarthquake = earthquake
                } label: {
                    EarthquakeRow(earthquake: earthquake)
                }
                .buttonStyle(.plain)
            }
            .sheet(item: self.$selectedEarthquake) { earthquake in
                VStack {
                    MapView(latitude: Double(earthquake.latitude)!, longitude: Double(earthquake.longitude)!)
                        .frame(height: 400)
                    Text(earthquake.location)
                    Spacer()
                }
                .presentationDetents([.fraction(0.7)])
                .presentationDragIndicator(.visible)
            }.task {
                await getLastEarthquakes()
            }
            .navigationTitle("Last Earthquakes in Turkey")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    func getLastEarthquakes() async {
        do {
            let url = "https://deprem.afad.gov.tr/apiv2/event/filter?start=2023-02-24&end=2023-02-24 20:10:00&orderby=timedesc"
            guard let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            let mainUrl = URL(string: urlString)!
            let (data, _) = try await URLSession.shared.data(from: mainUrl)
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
