//
//  InitializationView.swift
//  CramForRounds
//

import SwiftUI

struct InitializationView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var mlxManager: MLXManager

    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(hex: "2a7ae2"))

                Text("Cram For Rounds")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("AI-powered study guide generator for medical students")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Privacy badge
            HStack {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(.green)
                Text("100% On-Device • Private • No Data Sent")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.green.opacity(0.1))
            .cornerRadius(20)

            Spacer()

            // Warning box
            VStack(alignment: .leading, spacing: 12) {
                Label("Important", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
                    .foregroundColor(Color(hex: "d97706"))

                VStack(alignment: .leading, spacing: 8) {
                    Text("• For educational purposes only")
                    Text("• Not for clinical decision making")
                    Text("• AI may produce inaccurate information")
                    Text("• Do not input real patient data")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color(hex: "fef3c7"), Color(hex: "fde68a")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()

            // Status panel
            VStack(spacing: 16) {
                if mlxManager.isLoading {
                    VStack(spacing: 12) {
                        ProgressView(value: mlxManager.downloadProgress)
                            .tint(Color(hex: "2a7ae2"))

                        Text(mlxManager.statusMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5)
                } else if mlxManager.isInitialized {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("AI Ready!")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5)
                }

                if let error = mlxManager.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }

                // Initialize button
                if !mlxManager.isInitialized && !mlxManager.isLoading {
                    Button(action: {
                        Task {
                            await mlxManager.initialize()
                            if mlxManager.isInitialized {
                                appState.currentPhase = .inputCase
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                            Text("Initialize AI Model")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "2a7ae2"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                } else if mlxManager.isInitialized {
                    Button(action: {
                        appState.currentPhase = .inputCase
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Get Started")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "059669"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)

            // Info text
            if !mlxManager.isInitialized {
                Text("First-time setup downloads ~2GB model (one-time only)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    InitializationView(mlxManager: MLXManager())
        .environmentObject(AppState())
}
