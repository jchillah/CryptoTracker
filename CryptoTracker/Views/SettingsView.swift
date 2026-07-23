//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 17.03.25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false

    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var showsDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                accountSection
                appearanceSection
                sessionSection

                if let message = viewModel.updateMessage {
                    Section("Status") {
                        Text(message)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("settingsStatusMessage")
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .disabled(viewModel.isLoading)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .controlSize(.large)
                        .accessibilityLabel("Änderung wird gespeichert")
                }
            }
            .confirmationDialog(
                "Account dauerhaft löschen?",
                isPresented: $showsDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Account endgültig löschen", role: .destructive) {
                    Task { await viewModel.deleteAccount() }
                }
                Button("Abbrechen", role: .cancel) { }
            } message: {
                Text("Dabei werden Ihr Firebase-Account, Ihre Favoriten und Ihre Einstellungen gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.")
            }
        }
    }

    private var accountSection: some View {
        Section("Account") {
            TextField("Neue E-Mail", text: $viewModel.newEmail)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.emailAddress)

            Button("E-Mail aktualisieren") {
                Task { await viewModel.updateEmailSetting() }
            }
            .disabled(viewModel.newEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            PasswordFieldView(
                title: "Neues Passwort",
                text: $viewModel.newPassword,
                showPassword: $showPassword
            )
            .textContentType(.newPassword)

            PasswordFieldView(
                title: "Passwort bestätigen",
                text: $viewModel.newPasswordConfirm,
                showPassword: $showConfirmPassword
            )
            .textContentType(.newPassword)

            Button("Passwort aktualisieren") {
                Task { await viewModel.updatePassword() }
            }
            .disabled(viewModel.newPassword.isEmpty || viewModel.newPasswordConfirm.isEmpty)
        }
    }

    private var appearanceSection: some View {
        Section("Darstellung") {
            Toggle("Dark Mode", isOn: $isDarkMode)
                .onChange(of: isDarkMode) { _, newValue in
                    Task { await viewModel.setDarkMode(newValue) }
                }
        }
    }

    private var sessionSection: some View {
        Section {
            Button("Abmelden", role: .destructive) {
                Task { await viewModel.signOut() }
            }

            Button("Account löschen", role: .destructive) {
                showsDeleteConfirmation = true
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}
