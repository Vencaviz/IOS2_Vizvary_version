//
//  FitnessPrimaryButtonStyle.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  Jednoduchý, opakovaně použitelný styl tlačítka („New exercise“, „Record“),
//  aby UI vypadalo konzistentně a nemuseli jsme styl kopírovat do každého View.
//

import SwiftUI

struct FitnessPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .fill(Color(red: 0.34, green: 0.74, blue: 0.96)) // podobná modrá jako v mockupu
            )
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

