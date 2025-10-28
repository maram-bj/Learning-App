//
//  ButtonUtils.swift
//  L- New
//
//  Created by Maram on 02/05/1447 AH.
//

import SwiftUI

// MARK: - Button Styling Utilities
struct ButtonUtils {
    
    // MARK: - Common Shadow Styles
    static let primaryShadow = [
        Shadow(color: Color.white.opacity(0.7), radius: 0.1, x: 0.7, y: 0.5),
        Shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.5, y: -0.5)
    ]
    
    static let freezeShadow = [
        Shadow(color: Color.white.opacity(0.6), radius: 1, x: 0.9, y: 0.9),
        Shadow(color: Color.white.opacity(0.6), radius: 1, x: -0.9, y: -0.9)
    ]
    
    static let disabledShadow = [
        Shadow(color: Color.cyan.opacity(1), radius: 2, x: 0.8, y: 0.8),
        Shadow(color: Color.cyan.opacity(1), radius: 2, x: -0.8, y: -0.8)
    ]
    
    // MARK: - Button Builders
    static func choiceButton(title: String, isSelected: Binding<String>) -> some View {
        HStack {
            Button(action: { isSelected.wrappedValue = title }) {
                textMediumWhite(title: title, size: 17)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.glassProminent)
            .tint(isSelected.wrappedValue == title ? Color("Color") : Color(.gray.opacity(0.1)))
            .applyShadows(primaryShadow)
            .controlSize(.large)
            .buttonBorderShape(.capsule)
        }
        .frame(width: 97, height: 48)
    }
    
    static func startButton(color: Color, title: String, isSelected: Binding<Bool>, action: @escaping () -> Void) -> some View {
        HStack {
            Button(action: {
                isSelected.wrappedValue = true
                action()
            }) {
                textMediumWhite(title: title, size: 17)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.glassProminent)
            .applyShadows(primaryShadow)
            .controlSize(.large)
            .buttonBorderShape(.capsule)
            .frame(width: 182, height: 48)
            .tint(isSelected.wrappedValue ? color : Color.gray.opacity(0.3))
        }
    }
    
    static func startButton(color: Color, title: String, action: @escaping () -> Void) -> some View {
        HStack {
            Button(action: action) {
                textMediumWhite(title: title, size: 17)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.glassProminent)
            .applyShadows(primaryShadow)
            .controlSize(.large)
            .buttonBorderShape(.capsule)
            .frame(width: 182, height: 48)
        }
    }
}

// MARK: - Shadow Extension
extension View {
    func applyShadows(_ shadows: [Shadow]) -> some View {
        var result: AnyView = AnyView(self)
        for shadow in shadows {
            result = AnyView(result.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y))
        }
        return result
    }
}

// MARK: - Shadow Model
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}
