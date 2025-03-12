//
//  CryptoService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

class CryptoService {
    
    func fetchCryptoData() async throws -> [Crypto] {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Crypto].self, from: data)
    }
}
