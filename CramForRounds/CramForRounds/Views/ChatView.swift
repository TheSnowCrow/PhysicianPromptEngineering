//
//  ChatView.swift
//  CramForRounds
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var mlxManager: MLXManager
    @StateObject private var chatViewModel: ChatViewModel

    @State private var inputText = ""
    @State private var showingExportSheet = false
    @FocusState private var isInputFocused: Bool

    init(mlxManager: MLXManager) {
        self.mlxManager = mlxManager
        _chatViewModel = StateObject(wrappedValue: ChatViewModel(mlxManager: mlxManager, appState: AppState()))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "stethoscope")
                                .foregroundColor(Color(hex: "2a7ae2"))

                            Text("Practice Rounds")
                                .font(.headline)
                                .fontWeight(.bold)
                        }

                        Text("Doc Pixel is ready to quiz you")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    // Action buttons
                    HStack(spacing: 12) {
                        Button(action: { showingExportSheet = true }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.body)
                                .foregroundColor(Color(hex: "2a7ae2"))
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 3)
                        }

                        Button(action: {
                            appState.startNewCase()
                            chatViewModel.reset()
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.body)
                                .foregroundColor(Color(hex: "2a7ae2"))
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 3)
                        }
                    }
                }
                .padding()
                .background(Color(hex: "f5f5f5"))

                Divider()
            }

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(chatViewModel.messages.filter { $0.role != .system }) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }

                        if chatViewModel.isGenerating {
                            HStack {
                                TypingIndicator()
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                .onChange(of: chatViewModel.messages.count) { _, _ in
                    if let lastMessage = chatViewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Info box (shown when empty)
            if chatViewModel.messages.filter({ $0.role != .system }).isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(Color(hex: "2a7ae2"))
                        .font(.title3)

                    Text("How it works")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("Doc Pixel will ask you rounds-style questions about your case. Answer them, and you'll get feedback!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(hex: "eff6ff"))
                .cornerRadius(12)
                .padding()
            }

            Divider()

            // Input area
            HStack(spacing: 12) {
                TextField("Type your answer...", text: $inputText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color(hex: "f5f5f5"))
                    .cornerRadius(20)
                    .focused($isInputFocused)
                    .lineLimit(1...5)

                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(
                            inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || chatViewModel.isGenerating
                                ? Color.gray
                                : Color(hex: "2a7ae2")
                        )
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || chatViewModel.isGenerating)
            }
            .padding()
            .background(Color.white)
        }
        .background(Color(hex: "f5f5f5"))
        .onAppear {
            if let studyGuide = appState.currentStudyGuide {
                chatViewModel.startPracticeRounds(studyGuide: studyGuide)
            }
        }
        .sheet(isPresented: $showingExportSheet) {
            ExportSheet(
                studyGuide: appState.currentStudyGuide,
                messages: appState.conversationHistory
            )
        }
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        inputText = ""
        isInputFocused = false

        Task {
            await chatViewModel.sendMessage(text)
        }
    }
}

// MARK: - Message Bubble View
struct MessageBubbleView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .padding(12)
                    .background(backgroundColor)
                    .foregroundColor(textColor)
                    .cornerRadius(16)
                    .textSelection(.enabled)

                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.role == .user ? .trailing : .leading)

            if message.role != .user {
                Spacer()
            }
        }
    }

    private var backgroundColor: Color {
        switch message.role {
        case .user:
            return Color(hex: "2a7ae2")
        case .assistant:
            return Color.white
        case .system:
            return Color(hex: "fef3c7")
        }
    }

    private var textColor: Color {
        switch message.role {
        case .user:
            return .white
        case .assistant, .system:
            return .primary
        }
    }
}

// MARK: - Typing Indicator
struct TypingIndicator: View {
    @State private var animationAmount = 0.0

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animationAmount == Double(index) ? 1.3 : 1.0)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                animationAmount = 2.0
            }
        }
    }
}

// MARK: - Export Sheet
struct ExportSheet: View {
    @Environment(\.dismiss) var dismiss
    let studyGuide: StudyGuide?
    let messages: [Message]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(hex: "2a7ae2"))

                Text("Export Study Session")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Your study guide and practice session will be exported as a Markdown file")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                Button(action: exportMarkdown) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Markdown File")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "2a7ae2"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                Button("Cancel") {
                    dismiss()
                }
                .padding(.bottom)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func exportMarkdown() {
        guard let studyGuide = studyGuide else { return }

        let markdown = studyGuide.exportAsMarkdown(with: messages)

        let activityVC = UIActivityViewController(
            activityItems: [markdown],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController?.presentedViewController ?? window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }

        dismiss()
    }
}

#Preview {
    ChatView(mlxManager: MLXManager())
        .environmentObject(AppState())
}
