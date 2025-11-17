//
//  AppState.swift
//  CramForRounds
//

import Foundation

enum AppPhase {
    case initialization
    case inputCase
    case generatingStudyGuide
    case studyGuideReady
    case practiceRounds
}

@MainActor
class AppState: ObservableObject {
    @Published var currentPhase: AppPhase = .initialization
    @Published var currentStudyGuide: StudyGuide?
    @Published var conversationHistory: [Message] = []
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String?

    func reset() {
        currentPhase = .inputCase
        currentStudyGuide = nil
        conversationHistory = []
        isProcessing = false
        errorMessage = nil
    }

    func startNewCase() {
        currentStudyGuide = nil
        conversationHistory = []
        currentPhase = .inputCase
        errorMessage = nil
    }
}
