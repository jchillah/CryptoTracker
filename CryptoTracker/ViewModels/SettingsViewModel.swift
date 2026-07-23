//
//  SettingsViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import FirebaseAuth
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var newEmail = ""
    @Published var newPassword = ""
    @Published var newPasswordConfirm = ""
    @Published private(set) var updateMessage: String?
    @Published private(set) var isLoading = false

    @AppStorage("isDarkMode") private var storedDarkMode = false

    private let settingsRepository: SettingsRepository
    private let favoritesRepository: FavoritesRepository

    init(
        settingsRepository: SettingsRepository = .shared,
        favoritesRepository: FavoritesRepository = .shared
    ) {
        self.settingsRepository = settingsRepository
        self.favoritesRepository = favoritesRepository
    }

    func loadSettings() async {
        guard let userID = Auth.auth().currentUser?.uid else {
            updateMessage = nil
            return
        }

        do {
            let settings = try await settingsRepository.fetchSettings(for: userID)
            if let isDarkMode = settings["isDarkMode"] as? Bool {
                storedDarkMode = isDarkMode
            }
        } catch {
            updateMessage = error.localizedDescription
        }
    }

    func setDarkMode(_ isEnabled: Bool) async {
        storedDarkMode = isEnabled

        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        do {
            try await settingsRepository.updateDarkMode(
                isDarkMode: isEnabled,
                for: userID
            )
        } catch {
            updateMessage = error.localizedDescription
        }
    }

    func updateEmailSetting() async {
        let normalizedEmail = newEmail.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedEmail.isEmpty else {
            updateMessage = "Bitte geben Sie eine E-Mail-Adresse ein."
            return
        }

        guard let currentUser = Auth.auth().currentUser else {
            updateMessage = "Benutzer nicht gefunden."
            return
        }

        await performLoadingTask {
            try await withCheckedThrowingContinuation { continuation in
                currentUser.sendEmailVerification(beforeUpdatingEmail: normalizedEmail) { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }

            try await self.settingsRepository.updateEmail(
                newEmail: normalizedEmail,
                for: currentUser.uid
            )
            try await self.favoritesRepository.updateEmail(
                newEmail: normalizedEmail,
                for: currentUser.uid
            )

            self.newEmail = ""
            self.updateMessage = "Verifizierungs-E-Mail gesendet. Bitte bestätigen Sie die neue Adresse."
        }
    }

    func updatePassword() async {
        guard newPassword == newPasswordConfirm else {
            updateMessage = "Passwörter stimmen nicht überein."
            return
        }

        guard newPassword.count >= 8 else {
            updateMessage = "Das Passwort muss mindestens 8 Zeichen lang sein."
            return
        }

        guard let currentUser = Auth.auth().currentUser else {
            updateMessage = "Benutzer nicht gefunden."
            return
        }

        await performLoadingTask {
            try await withCheckedThrowingContinuation { continuation in
                currentUser.updatePassword(to: self.newPassword) { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }

            self.newPassword = ""
            self.newPasswordConfirm = ""
            self.updateMessage = "Passwort erfolgreich aktualisiert."
        }
    }

    func signOut() async {
        do {
            try AuthService.shared.signOut()
        } catch {
            updateMessage = error.localizedDescription
        }
    }

    func deleteAccount() async {
        guard let currentUser = Auth.auth().currentUser else {
            updateMessage = "Benutzer nicht gefunden."
            return
        }

        await performLoadingTask {
            try await self.settingsRepository.deleteSettings(for: currentUser.uid)

            try await withCheckedThrowingContinuation { continuation in
                currentUser.delete { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }

            self.updateMessage = nil
        }
    }

    private func performLoadingTask(
        _ operation: @escaping () async throws -> Void
    ) async {
        updateMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await operation()
        } catch let error as NSError {
            if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                updateMessage = "Bitte melden Sie sich erneut an, um diese Änderung vorzunehmen."
            } else {
                updateMessage = error.localizedDescription
            }
        }
    }
}
