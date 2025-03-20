//
//  FavoritesRepository.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 18.03.25.
//

import Foundation
import FirebaseFirestore

class FavoritesRepository {
    static let shared = FavoritesRepository()
    private let db = Firestore.firestore()
    
    private init() { }
    
    func updateFavorites(favorites: Set<String>, for userId: String, userEmail: String) async throws {
        let favoritesArray = Array(favorites)
        try await db.collection("users").document(userId).setData([
            "favorites": favoritesArray,
            "email": userEmail
        ], merge: true)
    }
    
    func updateEmail(newEmail: String, for userId: String) async throws {
        try await db.collection("users").document(userId).updateData([
            "email": newEmail
        ])
    }
    
    func fetchFavorites(for userId: String) async throws -> Set<String> {
        let document = try await db.collection("users").document(userId).getDocument()
        if let data = document.data(), let favArray = data["favorites"] as? [String] {
            return Set(favArray)
        }
        return []
    }
    
    func deleteFavorites(for userId: String) async throws {
        try await db.collection("users").document(userId).updateData(["favorites": FieldValue.delete()])
    }
}
