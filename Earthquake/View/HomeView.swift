//
//  HomeView.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 2.03.2023.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var vm = EarthquakeViewModel()
    @State private var isPresented: Bool = false
    @State private var selectedEarthquake: Earthquake? = nil
    
    
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
                            await vm.getLastEarthquakes()
                        }
                }
            }
            .navigationTitle("Earthquakes in Turkey")
            .searchable(text: $vm.searchText)
            .fullScreenCover(item: self.$selectedEarthquake) { earthquake in
                EarthquakeBottomSheetView(earthquake: earthquake)
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    toolbarLeadingContent
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarTrailingContent
                }
            })
        }.task {
            await vm.getLastEarthquakes()
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
        Picker("Mag: ", selection: $vm.selectedMag) {
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
        .onChange(of: vm.selectedMag, perform: { value in
            Task {
                await vm.getLastEarthquakes()
            }
        })
    }
    
    var toolbarTrailingContent: some View {
        DatePicker("", selection: $vm.selectedDate, in: ...Date(), displayedComponents: [.date])
            .onChange(of: vm.selectedDate, perform: { value in
                Task {
                    await vm.getLastEarthquakes()
                }
            })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
