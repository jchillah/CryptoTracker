//
//  AuthService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 17.03.25.
//

import FirebaseAuth
import Foundation

final class AuthService {
    static let shared = AuthService()

    private init() { }

    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(
            withEmail: email,
            password: password
        )
        return result.user
    }

    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(
            withEmail: email,
            password: password
        )
        return result.user
    }

    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func addAuthStateListener(
        _ listener: @escaping (User?) -> Void
    ) -> AuthStateDidChangeListenerHandle {
        Auth.auth().addStateDidChangeListener { _, user in
            listener(user)
        }
    }

    func removeAuthStateListener(
        _ handle: AuthStateDidChangeListenerHandle
    ) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
