//
//  ContentView.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 21.02.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var selection = 0
    // .environment(\.symbolVariants, .none) -> without this, tab bar icon is always filled
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: selection == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: selection == 1 ? "map.fill" : "map")
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)
        }.accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
