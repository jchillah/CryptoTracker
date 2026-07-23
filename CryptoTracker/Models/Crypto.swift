//
//  Crypto.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

struct Crypto: Identifiable, Decodable, Sendable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double
    let marketCapRank: Int
    let volume: Double
    let high24h: Double
    let low24h: Double
    let priceChange24h: Double
    let priceChangePercentage24h: Double
    let lastUpdated: String

    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case volume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case lastUpdated = "last_updated"
    }

    init(
        id: String,
        symbol: String,
        name: String,
        image: String,
        currentPrice: Double,
        marketCap: Double,
        marketCapRank: Int,
        volume: Double,
        high24h: Double,
        low24h: Double,
        priceChange24h: Double,
        priceChangePercentage24h: Double,
        lastUpdated: String
    ) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.volume = volume
        self.high24h = high24h
        self.low24h = low24h
        self.priceChange24h = priceChange24h
        self.priceChangePercentage24h = priceChangePercentage24h
        self.lastUpdated = lastUpdated
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        currentPrice = try container.decodeIfPresent(Double.self, forKey: .currentPrice) ?? 0
        marketCap = try container.decodeIfPresent(Double.self, forKey: .marketCap) ?? 0
        marketCapRank = try container.decodeIfPresent(Int.self, forKey: .marketCapRank) ?? 0
        volume = try container.decodeIfPresent(Double.self, forKey: .volume) ?? 0
        high24h = try container.decodeIfPresent(Double.self, forKey: .high24h) ?? 0
        low24h = try container.decodeIfPresent(Double.self, forKey: .low24h) ?? 0
        priceChange24h = try container.decodeIfPresent(Double.self, forKey: .priceChange24h) ?? 0
        priceChangePercentage24h = try container.decodeIfPresent(
            Double.self,
            forKey: .priceChangePercentage24h
        ) ?? 0
        lastUpdated = try container.decodeIfPresent(String.self, forKey: .lastUpdated)
            ?? ISO8601DateFormatter().string(from: .now)
    }
}
