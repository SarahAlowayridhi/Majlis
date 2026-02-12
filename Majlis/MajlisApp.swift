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

    // Persisted flags/profile
    @AppStorage("onboardingCompleted") private var onboardingCompleted: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if onboardingCompleted {
                    // Returning user → go straight to Map with persisted profile
                    ReturningUserRoot()
                        .opacity(showSplash ? 0 : 1)
                } else {
                    // First run → character selection flow
                    NavigationStack {
                        CharacterSelection(viewModel: MajlisViewModel())
                            .navigationBarBackButtonHidden(true)
                    }
                    .opacity(showSplash ? 0 : 1)
                }

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

// A small wrapper view to own the returning user's MajlisViewModel
private struct ReturningUserRoot: View {
    @StateObject private var vm = MajlisViewModel()

    var body: some View {
        // ContentView already has its own NavigationStack; no need to nest another here.
        ContentView(majlisVM: vm)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                vm.loadPersistedProfile()
            }
    }
}
