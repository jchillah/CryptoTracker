//
//  FavoritesRepository.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 18.03.25.
//

import FirebaseFirestore
import Foundation

final class FavoritesRepository {
    static let shared = FavoritesRepository()

    private let database: Firestore

    private init(database: Firestore = .firestore()) {
        self.database = database
    }

    func updateFavorites(
        favorites: Set<String>,
        for userID: String
    ) async throws {
        try await userDocument(userID).setData(
            ["favorites": Array(favorites).sorted()],
            merge: true
        )
    }

    func fetchFavorites(for userID: String) async throws -> Set<String> {
        let document = try await userDocument(userID).getDocument()
        let values = document.data()?["favorites"] as? [String] ?? []
        return Set(values)
    }

    func deleteFavorites(for userID: String) async throws {
        try await userDocument(userID).updateData(
            ["favorites": FieldValue.delete()]
        )
    }

    private func userDocument(_ userID: String) -> DocumentReference {
        database.collection("users").document(userID)
    }
}
