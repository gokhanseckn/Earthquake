//
//  MagnitudeCard.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 2.03.2023.
//

import SwiftUI


struct MagnitudeCard: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding()
            .background(color)
            .cornerRadius(10)
    }
}

extension View {
    func magnitudeCard(color: Color) -> some View {
        modifier(MagnitudeCard(color: color))
    }
}
