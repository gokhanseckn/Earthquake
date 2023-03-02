//
//  CardBackground.swift
//  Earthquake
//
//  Created by Gokhan Seckin on 2.03.2023.
//

import SwiftUI

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThickMaterial)
            )
    }
}


extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}
