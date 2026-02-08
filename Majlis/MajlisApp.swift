//
//  MajlisApp.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 13/08/1447 AH.
//

import SwiftUI

@main
struct MajlisApp: App {
    @State private var showSplash: Bool = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main app flow (what you previously launched)
                NavigationStack {
                    CharacterSelection(viewModel: MajlisViewModel())
                }
                .opacity(showSplash ? 0 : 1)

                // Splash on top initially
                if showSplash {
                    StartScreen()
                        .transition(.opacity)
                }
            }
            .onAppear {
                // Keep splash for ~2 seconds, then fade to main
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
