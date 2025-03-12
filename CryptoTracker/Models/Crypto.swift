//
//  Crypto.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

struct Crypto: Identifiable, Decodable {
    let id: String
    let name: String
    let symbol: String
    let price: Double
    let marketCap: Double
    let volume: Double
    let priceChangePercentage24h: Double
    let high24h: Double
    let low24h: Double
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case price = "current_price"
        case marketCap = "market_cap"
        case volume = "total_volume"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case high24h = "high_24h"
        case low24h = "low_24h"
    }
}
