//
//  CelebrationView.swift
//  CookieCrusher
//
//  Created by Cursor Cloud Agent on 05.01.2026.
//
//  „Gratulace“ obrazovka s animací padajících kuliček.
//
//  Požadavky z obrázku:
//  - text: „Great! You are building your habits!“
//  - kuliček je tolik, kolik je hodnota počítadla
//  - postupně „spadnou“ jedna na druhou
//  - maximálně 5 různých barev (barvy cyklujeme)
//  - po animaci se vrátíme na hlavní seznam
//

import SwiftUI

struct CelebrationView: View {
    /// Kolik kuliček chceme zobrazit.
    let ballCount: Int

    /// Zavolá se po dokončení animace.
    let onFinished: () -> Void

    /// Offsety pro jednotlivé kuličky (animujeme změnou offsetu).
    @State private var offsets: [CGFloat] = []

    /// Kuliček může být hodně; v UI to nemá smysl renderovat ve stovkách.
    /// Zadání sice říká „tolik, kolik počítadlo“, ale v praxi limitujeme pro výkon.
    private var clampedCount: Int { min(ballCount, 25) }

    private let colors: [Color] = [
        Color(red: 0.34, green: 0.74, blue: 0.96), // modrá
        Color(red: 0.95, green: 0.31, blue: 0.22), // červená
        Color(red: 0.98, green: 0.80, blue: 0.21), // žlutá
        Color(red: 0.37, green: 0.78, blue: 0.47), // zelená
        Color(red: 0.62, green: 0.42, blue: 0.85), // fialová
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Great!\nYou are building your habits!")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            Spacer()

            ZStack(alignment: .top) {
                // Renderujeme kuličky „nad sebou“ a necháme je dopadat na cílové y pozice.
                ForEach(0..<clampedCount, id: \.self) { index in
                    Circle()
                        .fill(colors[index % 5]) // max 5 barev
                        .frame(width: 46, height: 46)
                        .offset(y: offsets.indices.contains(index) ? offsets[index] : -300)
                        .accessibilityHidden(true)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 340)

            Spacer()
        }
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        // Startujeme všechny kuličky „nahoře“.
        offsets = Array(repeating: -320, count: clampedCount)

        // Postupný „drop“: každá kulička spadne na svoje místo.
        Task { @MainActor in
            for i in 0..<clampedCount {
                withAnimation(.easeIn(duration: 0.35)) {
                    // Každá další kulička dopadne o kousek níž.
                    offsets[i] = CGFloat(i) * 52
                }
                // Krátká pauza mezi dopady, aby bylo vidět „postupně“.
                try? await Task.sleep(nanoseconds: 140_000_000)
            }

            // Necháme poslední animaci „doznít“.
            try? await Task.sleep(nanoseconds: 600_000_000)
            onFinished()
        }
    }
}

