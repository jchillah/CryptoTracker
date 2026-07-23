//
//  CryptoService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation
import SwiftData

enum CryptoDataSource {
    case remote
    case cache
}

struct CryptoFetchResult {
    let coins: [Crypto]
    let source: CryptoDataSource
}

enum CryptoServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case rateLimited
    case httpStatus(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Die Anfrage konnte nicht erstellt werden."
        case .invalidResponse:
            return "Der Server hat keine gültige Antwort geliefert."
        case .rateLimited:
            return "Das API-Limit wurde erreicht. Bitte versuchen Sie es später erneut."
        case .httpStatus(let statusCode):
            return "Die Anfrage ist mit HTTP-Status \(statusCode) fehlgeschlagen."
        }
    }
}

@MainActor
final class CryptoService {
    private enum Constants {
        static let marketsURL = URL(string: "https://api.coingecko.com/api/v3/coins/markets")
        static let exchangeRatesURL = URL(string: "https://api.coingecko.com/api/v3/exchange_rates")
        static let requestTimeout: TimeInterval = 20
    }

    private let modelContext: ModelContext
    private let session: URLSession
    private var exchangeRates: [String: Double] = [:]

    init(
        modelContext: ModelContext,
        session: URLSession = .shared
    ) {
        self.modelContext = modelContext
        self.session = session
    }

    func fetchCryptoData(for currency: String) async throws -> CryptoFetchResult {
        do {
            let coins = try await fetchRemoteCryptoData(for: currency)
            try persist(coins)
            return CryptoFetchResult(coins: coins, source: .remote)
        } catch {
            let cachedCoins = try loadCachedCoins()
            guard !cachedCoins.isEmpty else {
                throw error
            }
            return CryptoFetchResult(coins: cachedCoins, source: .cache)
        }
    }

    func fetchExchangeRates() async throws {
        guard let url = Constants.exchangeRatesURL else {
            throw CryptoServiceError.invalidURL
        }

        let data = try await requestData(from: url)
        let response = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
        exchangeRates = response.rates.mapValues(\.value)
    }

    func getConversionRate(for currency: String) -> Double {
        exchangeRates[currency.lowercased()] ?? 1
    }

    private func fetchRemoteCryptoData(for currency: String) async throws -> [Crypto] {
        guard let baseURL = Constants.marketsURL,
              var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw CryptoServiceError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: currency.lowercased()),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sparkline", value: "false"),
            URLQueryItem(name: "price_change_percentage", value: "24h")
        ]

        guard let url = components.url else {
            throw CryptoServiceError.invalidURL
        }

        let data = try await requestData(from: url)
        return try JSONDecoder().decode([Crypto].self, from: data)
    }

    private func requestData(from url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.timeoutInterval = Constants.requestTimeout
        request.cachePolicy = .reloadRevalidatingCacheData
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CryptoServiceError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 429:
            throw CryptoServiceError.rateLimited
        default:
            throw CryptoServiceError.httpStatus(httpResponse.statusCode)
        }
    }

    private func persist(_ coins: [Crypto]) throws {
        let storedEntities = try modelContext.fetch(FetchDescriptor<CryptoEntity>())
        let entitiesByID = Dictionary(uniqueKeysWithValues: storedEntities.map { ($0.id, $0) })
        let incomingIDs = Set(coins.map(\.id))

        for coin in coins {
            if let existingEntity = entitiesByID[coin.id] {
                existingEntity.update(from: coin)
            } else {
                modelContext.insert(CryptoEntity(from: coin))
            }
        }

        for entity in storedEntities where !incomingIDs.contains(entity.id) {
            modelContext.delete(entity)
        }

        try modelContext.save()
    }

    private func loadCachedCoins() throws -> [Crypto] {
        var descriptor = FetchDescriptor<CryptoEntity>(
            sortBy: [SortDescriptor(\CryptoEntity.marketCapRank)]
        )
        descriptor.fetchLimit = 100
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }
}
