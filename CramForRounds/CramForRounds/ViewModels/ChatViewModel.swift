//
//  ChatViewModel.swift
//  CramForRounds
//

import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isGenerating = false
    @Published var currentStreamedMessage = ""

    private let mlxManager: MLXManager
    private let appState: AppState

    init(mlxManager: MLXManager, appState: AppState) {
        self.mlxManager = mlxManager
        self.appState = appState
    }

    /// Send a user message and get AI response
    func sendMessage(_ content: String) async {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard !isGenerating else { return }

        // Add user message
        let userMessage = Message(role: .user, content: content)
        messages.append(userMessage)
        appState.conversationHistory.append(userMessage)

        isGenerating = true
        currentStreamedMessage = ""

        do {
            // Get AI response with streaming
            let assistantMessage = Message(role: .assistant, content: "")
            messages.append(assistantMessage)

            try await mlxManager.streamRoundsResponse(
                conversationHistory: buildContextWindow()
            ) { token in
                self.currentStreamedMessage += token
                // Update the last message
                if let lastIndex = self.messages.indices.last {
                    self.messages[lastIndex] = Message(
                        id: self.messages[lastIndex].id,
                        role: .assistant,
                        content: self.currentStreamedMessage
                    )
                }
            }

            // Save final message to app state
            if let lastMessage = messages.last {
                appState.conversationHistory.append(lastMessage)
            }

            currentStreamedMessage = ""
            isGenerating = false

        } catch {
            // Remove the empty assistant message
            if messages.last?.role == .assistant && messages.last?.content.isEmpty == true {
                messages.removeLast()
            }

            // Add error message
            let errorMsg = Message(role: .system, content: "Error: \(error.localizedDescription)")
            messages.append(errorMsg)
            isGenerating = false
        }
    }

    /// Initialize the practice rounds conversation
    func startPracticeRounds(studyGuide: StudyGuide) {
        messages.removeAll()
        appState.conversationHistory.removeAll()

        let systemMessage = Message(
            role: .system,
            content: """
            You are Doc Pixel, an attending physician conducting teaching rounds. You have just reviewed a study guide with your medical student. Now it's time to quiz them on the material.

            Study Guide Context:
            \(studyGuide.generatedContent)

            Your role:
            - Ask challenging, rounds-style questions about this case
            - Provide constructive feedback on their answers
            - Probe deeper when answers are incomplete
            - Maintain a supportive but rigorous teaching style
            - Keep responses concise and focused

            Start by greeting the student and asking your first question.
            """
        )

        messages.append(systemMessage)
        appState.conversationHistory.append(systemMessage)

        // Get initial AI greeting/question
        Task {
            await getInitialQuestion()
        }
    }

    private func getInitialQuestion() async {
        isGenerating = true
        currentStreamedMessage = ""

        do {
            let assistantMessage = Message(role: .assistant, content: "")
            messages.append(assistantMessage)

            try await mlxManager.streamRoundsResponse(
                conversationHistory: buildContextWindow()
            ) { token in
                self.currentStreamedMessage += token
                if let lastIndex = self.messages.indices.last {
                    self.messages[lastIndex] = Message(
                        id: self.messages[lastIndex].id,
                        role: .assistant,
                        content: self.currentStreamedMessage
                    )
                }
            }

            if let lastMessage = messages.last {
                appState.conversationHistory.append(lastMessage)
            }

            currentStreamedMessage = ""
            isGenerating = false

        } catch {
            if messages.last?.role == .assistant && messages.last?.content.isEmpty == true {
                messages.removeLast()
            }
            let errorMsg = Message(role: .system, content: "Error starting practice: \(error.localizedDescription)")
            messages.append(errorMsg)
            isGenerating = false
        }
    }

    /// Build context window with last 6 messages (like web version)
    private func buildContextWindow() -> [Message] {
        let maxMessages = 7 // System message + 6 conversation messages
        if messages.count <= maxMessages {
            return messages
        } else {
            // Keep system message and last 6 messages
            var context = [messages[0]] // System message
            context.append(contentsOf: messages.suffix(6))
            return context
        }
    }

    func reset() {
        messages.removeAll()
        isGenerating = false
        currentStreamedMessage = ""
    }
}
