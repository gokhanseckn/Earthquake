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
            
            mapView
            
            if vm.isLoading {
                ProgressView()
                    .padding()
                    .cardBackground()
            }
            
            VStack {
                HStack {
                    toolbarLeadingContent
                    Spacer()
                    toolbarTrailingContent
                }
                .padding()
                
                Spacer()
                
                VStack {
                    if vm.earthquakes.isEmpty {
                        Text("There is no earthquake")
                    } else {
                        cardView
                    }
                }
                .padding()
                .cardBackground()
                .padding()
            }
        }
        .task {
            await vm.getLastEarthquakes()
        }
    }
    
    var mapView: some View {
        Map(coordinateRegion:
                .constant(MKCoordinateRegion(
                    center: vm.mapRegion,
                    span: MKCoordinateSpan(latitudeDelta: 7, longitudeDelta: 7))
                ),
            annotationItems: vm.cities
        ) { place in
            MapAnnotation(coordinate: place.coordinate) {
                Image(systemName: "mappin.circle.fill")
                    .renderingMode(.original)
                    .shadow(radius: 4)
                    .font(.title)
                    .scaleEffect(
                        String(place.coordinate.latitude) == vm.currentEarthquake.latitude && String(place.coordinate.longitude) == vm.currentEarthquake.longitude
                        ? 1.2 : 0.7
                    )
            }
        }
    }
    
    var toolbarLeadingContent: some View {
        Picker("Mag: ", selection: $vm.selectedMag) {
            Text("> 3")
                .tag("3")
            Text("> 5")
                .tag("5")
        }
        .tint(.black)
        .cardBackground()
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
            .cardBackground()
            .onChange(of: vm.selectedDate, perform: { value in
                Task {
                    await vm.getLastEarthquakes()
                }
            })
    }
    
    var cardView: some View {
        HStack {
            Text(String(format: "%.1f", Double(vm.currentEarthquake.magnitude) ?? "0"))
                .magnitudeCard(color: vm.currentEarthquake.color)
            VStack(alignment: .leading) {
                Text(vm.currentEarthquake.province ?? vm.currentEarthquake.location)
                    .font(.headline)
                    .lineLimit(1)
                Text(vm.currentEarthquake.district ?? "")
                    .foregroundColor(.black.opacity(0.6))
                HStack {
                    Text("\(Earthquake.dateFormatter.string(from: vm.currentEarthquake.formattedDate)) •")
                    Text(Earthquake.relativeDateTimeFormatter.localizedString(for: vm.currentEarthquake.formattedDate, relativeTo: Date.now))
                }
                .font(.footnote)
                .fontWeight(.regular)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                vm.nextButtonPressed()
            } label: {
                Text("Next")
            }
            .buttonStyle(.plain)
            .padding()
            .background(.gray.opacity(0.2))
            .cornerRadius(10)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
