//
//  SettingsRepository.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 19.03.25.
//

import FirebaseFirestore
import Foundation

final class SettingsRepository {
    static let shared = SettingsRepository()

    private let database: Firestore

    private init(database: Firestore = .firestore()) {
        self.database = database
    }

    func fetchSettings(for userID: String) async throws -> [String: Any] {
        let document = try await userDocument(userID).getDocument()
        return document.data() ?? [:]
    }

    func updateDarkMode(
        isDarkMode: Bool,
        for userID: String
    ) async throws {
        try await userDocument(userID).setData(
            ["isDarkMode": isDarkMode],
            merge: true
        )
    }

    func deleteSettings(for userID: String) async throws {
        try await userDocument(userID).delete()
    }

    private func userDocument(_ userID: String) -> DocumentReference {
        database.collection("users").document(userID)
    }
}
