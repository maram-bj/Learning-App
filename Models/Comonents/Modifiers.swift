//
//  Modifiers.swift
//  Learning Challeng App
//
//  Created by Maram on 28/04/1447 AH.
//
import SwiftUI

struct GlassEffect: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .cornerRadius(13)
            //.glassEffect()
            .overlay(
                RoundedRectangle(cornerRadius: 13)
                    .stroke(Color.white.opacity(0.1), lineWidth: 2)
                    .shadow(color: Color.black.opacity(0.9), radius: 0.1, x: -0.9, y: -0.5)
                    .shadow(radius: 22)
                    .shadow(color: Color.white.opacity(0.8), radius: 0.1, x: 0.7, y: 0.5)
                   // .shadow(color: Color.black.opacity(1), radius: 0.1, x: -0.5, y: -0.5)
            )
    }
}

extension View {
    func glassStyle() -> some View {
        self.modifier(GlassEffect())
    }
}
