//
//  MapView.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 2.03.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var vm = EarthquakeViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion:
                    .constant(MKCoordinateRegion(
                        center: vm.mapRegion,
                        span: MKCoordinateSpan(latitudeDelta: 7, longitudeDelta: 7))
                    ),
                annotationItems: vm.cities
            ) { place in
                MapMarker(coordinate: place.coordinate)
            }
            
            VStack {
                HStack {
                    toolbarLeadingContent
                    Spacer()
                    toolbarTrailingContent
                }
                .padding()
                Spacer()
            }
        }
        .task {
            await vm.getLastEarthquakes()
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
        .tint(.black)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThickMaterial)
        )
        .onChange(of: vm.selectedMag, perform: { value in
            Task {
                await vm.getLastEarthquakes()
            }
        })
    }
    
    var toolbarTrailingContent: some View {
        DatePicker("", selection: $vm.selectedDate, in: ...Date(), displayedComponents: [.date])
            .frame(width: 106)
            .padding(.trailing, 6)
            .background( RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThickMaterial)
            )
            .onChange(of: vm.selectedDate, perform: { value in
                Task {
                    await vm.getLastEarthquakes()
                }
            })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
