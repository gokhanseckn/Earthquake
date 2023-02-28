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
    
    @State private var isLoading: Bool = false
    @State private var earthquakes = [Earthquake]()
    @State private var isPresented: Bool = false
    @State private var selectedEarthquake: Earthquake? = nil
    @State private var selectedDate: Date = Date()
    @State private var selectedMag: String = "3"
    @State private var searchText: String = ""
    
    var filteredEarthquakes: [Earthquake] {
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
            VStack {
                if isLoading {
                    ProgressView()
                } else if filteredEarthquakes.isEmpty {
                    VStack {
                        Text("There is no earthquake")
                        Spacer()
                    }
                } else {
                    listView
                }
            }
            .navigationTitle("Earthquakes in Turkey")
            .searchable(text: $searchText)
                .sheet(item: self.$selectedEarthquake) { earthquake in
                    BottomSheetView(earthquake: earthquake)
                        .presentationDetents([.fraction(0.7)])
                        .presentationDragIndicator(.visible)
                }.toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        toolbarLeadingContent
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        toolbarTrailingContent
                    }
                })
        }.task {
            await getLastEarthquakes(date: selectedDate, mag: selectedMag)
        }
    }
    
    
    var listView: some View {
        List(filteredEarthquakes, id: \.self) { earthquake in
            Button {
                self.selectedEarthquake = earthquake
            } label: {
                EarthquakeRow(earthquake: earthquake)
            }
            .buttonStyle(.plain)
        }
    }
    
    var toolbarLeadingContent: some View {
        Picker("Mag: ", selection: $selectedMag) {
            Text("All")
                .tag("1")
            Text("> 3")
                .tag("3")
            Text("> 5")
                .tag("5")
        }
        .padding(.trailing, 10)
        .tint(.black)
        .background(.gray.opacity(0.2))
        .cornerRadius(10)
        .onChange(of: selectedMag, perform: { value in
            Task {
                await getLastEarthquakes(date: selectedDate, mag: selectedMag)
            }
        })
    }
    
    var toolbarTrailingContent: some View {
        DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
            .onChange(of: selectedDate, perform: { value in
                Task {
                    await getLastEarthquakes(date: selectedDate, mag: selectedMag)
                }
            })
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
