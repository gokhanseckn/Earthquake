//
//  ContentView.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 21.02.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject private var vm = EarthquakeViewModel()
    @State private var isPresented: Bool = false
    @State private var selectedEarthquake: Earthquake? = nil
    @State private var selectedDate: Date = Date()
    @State private var selectedMag: String = "3"
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.isLoading {
                    ProgressView()
                } else if vm.filteredEarthquakes.isEmpty {
                    VStack {
                        Text("There is no earthquake")
                        Spacer()
                    }
                } else {
                    listView
                        .refreshable {
                            await vm.getLastEarthquakes(date: selectedDate, mag: selectedMag)
                        }
                }
            }
            .navigationTitle("Earthquakes in Turkey")
            .searchable(text: $vm.searchText)
                .sheet(item: self.$selectedEarthquake) { earthquake in
                    EarthquakeBottomSheetView(earthquake: earthquake)
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
            await vm.getLastEarthquakes(date: selectedDate, mag: selectedMag)
        }
    }
    
    var listView: some View {
        List(vm.filteredEarthquakes, id: \.self) { earthquake in
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
                await vm.getLastEarthquakes(date: selectedDate, mag: selectedMag)
            }
        })
    }
    
    var toolbarTrailingContent: some View {
        DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
            .onChange(of: selectedDate, perform: { value in
                Task {
                    await vm.getLastEarthquakes(date: selectedDate, mag: selectedMag)
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
