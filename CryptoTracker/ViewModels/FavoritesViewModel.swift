//
//  FavoritesViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 18.03.25.
//

import FirebaseAuth
import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var favoriteIDs: Set<String> = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading = false

    private let repository: FavoritesRepository

    init(repository: FavoritesRepository = .shared) {
        self.repository = repository
    }

    func loadFavorites() async {
        errorMessage = nil

        guard let userID = Auth.auth().currentUser?.uid else {
            favoriteIDs = []
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            favoriteIDs = try await repository.fetchFavorites(for: userID)
        } catch {
            favoriteIDs = []
            errorMessage = error.localizedDescription
        }
    }

    func toggleFavorite(coin: Crypto) async {
        guard let userID = Auth.auth().currentUser?.uid else {
            errorMessage = "Bitte melden Sie sich an, um Favoriten zu speichern."
            return
        }

        errorMessage = nil
        let previousFavorites = favoriteIDs

        if favoriteIDs.contains(coin.id) {
            favoriteIDs.remove(coin.id)
        } else {
            favoriteIDs.insert(coin.id)
        }

        do {
            try await repository.updateFavorites(
                favorites: favoriteIDs,
                for: userID
            )
        } catch {
            favoriteIDs = previousFavorites
            errorMessage = error.localizedDescription
        }
    }

    func isFavorite(coin: Crypto) -> Bool {
        favoriteIDs.contains(coin.id)
    }
}
