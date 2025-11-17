//
//  StudyGuideInputView.swift
//  CramForRounds
//

import SwiftUI

struct StudyGuideInputView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var mlxManager: MLXManager

    @State private var inputText = ""
    @State private var showingHelp = false
    @FocusState private var isInputFocused: Bool

    private let maxCharacters = 8000

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "2a7ae2"))

                        Text("Enter Your Case")
                            .font(.title2)
                            .fontWeight(.bold)
                    }

                    Text("Paste a clinical case or medical topic you want to study")
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                // Input area
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .topLeading) {
                        if inputText.isEmpty {
                            Text("Example:\n\n5yo male, fever 102.5 x 2 days, sore throat, + strep test, started amoxicillin\n\nor\n\n16yo female with worsening asthma, using albuterol 5-6x/day...")
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                        }

                        TextEditor(text: $inputText)
                            .frame(minHeight: 200)
                            .padding(4)
                            .focused($isInputFocused)
                            .scrollContentBackground(.hidden)
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isInputFocused ? Color(hex: "2a7ae2") : Color.gray.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)

                    // Character count
                    HStack {
                        Spacer()
                        Text("\(inputText.count) / \(maxCharacters)")
                            .font(.caption)
                            .foregroundColor(inputText.count > maxCharacters ? .red : .secondary)
                    }
                }

                // Tips box
                VStack(alignment: .leading, spacing: 8) {
                    Label("Tips for Best Results", systemImage: "lightbulb.fill")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "2a7ae2"))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Include key clinical details (age, symptoms, exam findings)")
                        Text("• Add test results if available")
                        Text("• Can be brief notes or detailed cases")
                        Text("• Works with any medical specialty")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(hex: "eff6ff"))
                .cornerRadius(12)

                // Generate button
                Button(action: generateStudyGuide) {
                    HStack {
                        if appState.isProcessing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "sparkles")
                        }

                        Text(appState.isProcessing ? "Generating..." : "Generate Study Guide")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || appState.isProcessing
                            ? Color.gray
                            : Color(hex: "2a7ae2")
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || appState.isProcessing)

                if let error = appState.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(error)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .onAppear {
            isInputFocused = true
        }
    }

    private func generateStudyGuide() {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        // Truncate if needed
        let finalText = String(trimmedText.prefix(maxCharacters))

        appState.isProcessing = true
        appState.currentPhase = .generatingStudyGuide
        appState.errorMessage = nil

        Task {
            do {
                let studyGuideContent = try await mlxManager.generateStudyGuide(from: finalText)

                let studyGuide = StudyGuide(
                    originalCase: finalText,
                    generatedContent: studyGuideContent
                )

                await MainActor.run {
                    appState.currentStudyGuide = studyGuide
                    appState.isProcessing = false
                    appState.currentPhase = .studyGuideReady
                }
            } catch {
                await MainActor.run {
                    appState.errorMessage = "Failed to generate study guide: \(error.localizedDescription)"
                    appState.isProcessing = false
                    appState.currentPhase = .inputCase
                }
            }
        }
    }
}

#Preview {
    StudyGuideInputView(mlxManager: MLXManager())
        .environmentObject(AppState())
}
