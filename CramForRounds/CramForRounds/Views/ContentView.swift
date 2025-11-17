//
//  ContentView.swift
//  CramForRounds
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var mlxManager = MLXManager()

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(hex: "f5f5f5"), Color(hex: "e8e8e8")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Main content based on app phase
                Group {
                    switch appState.currentPhase {
                    case .initialization:
                        InitializationView(mlxManager: mlxManager)

                    case .inputCase:
                        StudyGuideInputView(mlxManager: mlxManager)

                    case .generatingStudyGuide:
                        GeneratingView()

                    case .studyGuideReady:
                        StudyGuideResultView(mlxManager: mlxManager)

                    case .practiceRounds:
                        ChatView(mlxManager: mlxManager)
                    }
                }
            }
            .navigationTitle("Cram For Rounds")
            .navigationBarTitleDisplayMode(.large)
        }
        .environmentObject(mlxManager)
    }
}

// MARK: - Generating View
struct GeneratingView: View {
    @State private var animationAmount = 1.0

    var body: some View {
        VStack(spacing: 30) {
            ProgressView()
                .scaleEffect(2.0)
                .tint(Color(hex: "2a7ae2"))

            Text("Generating your study guide...")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .scaleEffect(animationAmount)
                .animation(
                    .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                    value: animationAmount
                )
                .onAppear {
                    animationAmount = 1.1
                }
        }
        .padding()
    }
}

// MARK: - Study Guide Result View
struct StudyGuideResultView: View {
    @EnvironmentObject var appState: AppState
    let mlxManager: MLXManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Success message
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)

                    Text("Study Guide Ready!")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)

                // Study guide content
                if let studyGuide = appState.currentStudyGuide {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Study Guide")
                            .font(.title3)
                            .fontWeight(.bold)

                        Text(studyGuide.generatedContent)
                            .font(.body)
                            .textSelection(.enabled)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }

                // Action buttons
                VStack(spacing: 12) {
                    Button(action: startPracticeRounds) {
                        HStack {
                            Image(systemName: "figure.walk")
                            Text("Start Practice Rounds")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "2a7ae2"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }

                    Button(action: exportSession) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export Study Guide")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color(hex: "2a7ae2"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "2a7ae2"), lineWidth: 2)
                        )
                    }

                    Button(action: appState.startNewCase) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Start New Case")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.secondary)
                        .cornerRadius(12)
                    }
                }
                .padding(.top)
            }
            .padding()
        }
    }

    private func startPracticeRounds() {
        appState.currentPhase = .practiceRounds
    }

    private func exportSession() {
        guard let studyGuide = appState.currentStudyGuide else { return }

        let markdown = studyGuide.exportAsMarkdown(with: appState.conversationHistory)

        // Create share sheet
        let activityVC = UIActivityViewController(
            activityItems: [markdown],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
