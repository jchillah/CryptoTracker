//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

@MainActor
class CryptoListViewModel: ObservableObject {
    @Published var coins: [Crypto] = []
    private let service = CryptoService()
    
    func fetchCoins() {
        Task {
            do {
                self.coins = try await service.fetchCryptoData()
            } catch {
                print("Fehler beim Laden: \(error)")
            }
        }
    }
}
