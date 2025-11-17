//
//  CramForRoundsApp.swift
//  CramForRounds
//
//  An iOS app for medical students to generate study guides and practice rounds
//  Runs entirely on-device using MLX Swift for privacy and offline access
//

import SwiftUI

@main
struct CramForRoundsApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
