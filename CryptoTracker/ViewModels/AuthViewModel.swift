//
//  AuthViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 17.03.25.
//

import FirebaseAuth
import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published private(set) var currentUser: User?
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var message: String?
    @Published private(set) var isLoading = false
    @Published var isRegistering = false

    private let authService: AuthService
    private var authStateListener: AuthStateDidChangeListenerHandle?

    init(authService: AuthService = .shared) {
        self.authService = authService
        authStateListener = authService.addAuthStateListener { [weak self] user in
            Task { @MainActor in
                self?.currentUser = user
            }
        }
    }

    deinit {
        if let authStateListener {
            authService.removeAuthStateListener(authStateListener)
        }
    }

    func signIn() async {
        guard validateCredentials() else { return }

        await performAuthOperation {
            _ = try await self.authService.signIn(
                email: self.normalizedEmail,
                password: self.password
            )
        }
    }

    func register(confirmPassword: String) async {
        guard validateCredentials() else { return }
        guard password == confirmPassword else {
            message = "Passwörter stimmen nicht überein."
            return
        }
        guard password.count >= 8 else {
            message = "Das Passwort muss mindestens 8 Zeichen lang sein."
            return
        }

        await performAuthOperation {
            _ = try await self.authService.signUp(
                email: self.normalizedEmail,
                password: self.password
            )
        }
    }

    func sendPasswordReset() async {
        guard !normalizedEmail.isEmpty else {
            message = "Bitte geben Sie zuerst Ihre E-Mail-Adresse ein."
            return
        }

        await performAuthOperation(successMessage: "E-Mail zum Zurücksetzen des Passworts wurde gesendet.") {
            try await self.authService.sendPasswordReset(
                email: self.normalizedEmail
            )
        }
    }

    func signOut() {
        do {
            try authService.signOut()
            clearCredentials()
        } catch {
            message = error.localizedDescription
        }
    }

    func switchMode() {
        isRegistering.toggle()
        message = nil
        password = ""
    }

    private var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func validateCredentials() -> Bool {
        guard normalizedEmail.contains("@") else {
            message = "Bitte geben Sie eine gültige E-Mail-Adresse ein."
            return false
        }
        guard !password.isEmpty else {
            message = "Bitte geben Sie Ihr Passwort ein."
            return false
        }
        return true
    }

    private func performAuthOperation(
        successMessage: String? = nil,
        _ operation: @escaping () async throws -> Void
    ) async {
        message = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await operation()
            message = successMessage
        } catch {
            message = error.localizedDescription
        }
    }

    private func clearCredentials() {
        email = ""
        password = ""
        message = nil
    }
}
