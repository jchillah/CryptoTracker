//
//  AuthView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 17.03.25.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel

    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(viewModel.isRegistering ? "Registrieren" : "Anmelden")
                    .font(.largeTitle.bold())

                TextField("E-Mail", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.emailAddress)
                    .accessibilityIdentifier("emailField")

                PasswordFieldView(
                    title: "Passwort",
                    text: $viewModel.password,
                    showPassword: $showPassword
                )
                .textContentType(viewModel.isRegistering ? .newPassword : .password)
                .accessibilityIdentifier("passwordField")

                if viewModel.isRegistering {
                    PasswordFieldView(
                        title: "Passwort bestätigen",
                        text: $confirmPassword,
                        showPassword: $showConfirmPassword
                    )
                    .textContentType(.newPassword)
                    .accessibilityIdentifier("confirmPasswordField")
                }

                if let message = viewModel.message {
                    Text(message)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("authMessage")
                }

                Button {
                    Task {
                        if viewModel.isRegistering {
                            await viewModel.register(
                                confirmPassword: confirmPassword
                            )
                        } else {
                            await viewModel.signIn()
                        }
                    }
                } label: {
                    Text(viewModel.isRegistering ? "Registrieren" : "Anmelden")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading)
                .accessibilityIdentifier("authSubmitButton")

                Button {
                    withAnimation {
                        viewModel.switchMode()
                        confirmPassword = ""
                    }
                } label: {
                    Text(
                        viewModel.isRegistering
                            ? "Bereits einen Account? Jetzt anmelden"
                            : "Noch keinen Account? Jetzt registrieren"
                    )
                    .font(.footnote)
                }
                .disabled(viewModel.isLoading)

                if !viewModel.isRegistering {
                    Button("Passwort vergessen?") {
                        Task { await viewModel.sendPasswordReset() }
                    }
                    .font(.footnote)
                    .disabled(viewModel.isLoading)
                }
            }
            .padding()
            .frame(maxWidth: 480)
            .frame(maxWidth: .infinity)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .accessibilityLabel("Anfrage wird verarbeitet")
            }
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel())
}
