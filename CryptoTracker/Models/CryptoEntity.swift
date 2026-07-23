//
//  CryptoEntity.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 19.03.25.
//

import Foundation
import SwiftData

@Model
final class CryptoEntity {
    @Attribute(.unique) var id: String
    var symbol: String
    var name: String
    var image: String
    var currentPrice: Double
    var marketCap: Double
    var marketCapRank: Int
    var volume: Double
    var high24h: Double
    var low24h: Double
    var priceChange24h: Double
    var priceChangePercentage24h: Double
    var lastUpdated: Date

    init(from crypto: Crypto) {
        id = crypto.id
        symbol = crypto.symbol
        name = crypto.name
        image = crypto.image
        currentPrice = crypto.currentPrice
        marketCap = crypto.marketCap
        marketCapRank = crypto.marketCapRank
        volume = crypto.volume
        high24h = crypto.high24h
        low24h = crypto.low24h
        priceChange24h = crypto.priceChange24h
        priceChangePercentage24h = crypto.priceChangePercentage24h
        lastUpdated = Self.date(from: crypto.lastUpdated)
    }

    func update(from crypto: Crypto) {
        symbol = crypto.symbol
        name = crypto.name
        image = crypto.image
        currentPrice = crypto.currentPrice
        marketCap = crypto.marketCap
        marketCapRank = crypto.marketCapRank
        volume = crypto.volume
        high24h = crypto.high24h
        low24h = crypto.low24h
        priceChange24h = crypto.priceChange24h
        priceChangePercentage24h = crypto.priceChangePercentage24h
        lastUpdated = Self.date(from: crypto.lastUpdated)
    }

    func toDomain() -> Crypto {
        Crypto(
            id: id,
            symbol: symbol,
            name: name,
            image: image,
            currentPrice: currentPrice,
            marketCap: marketCap,
            marketCapRank: marketCapRank,
            volume: volume,
            high24h: high24h,
            low24h: low24h,
            priceChange24h: priceChange24h,
            priceChangePercentage24h: priceChangePercentage24h,
            lastUpdated: ISO8601DateFormatter().string(from: lastUpdated)
        )
    }

    private static func date(from value: String) -> Date {
        ISO8601DateFormatter().date(from: value) ?? .now
    }
}
