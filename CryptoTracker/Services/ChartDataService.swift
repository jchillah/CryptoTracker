//
//  ChartDataService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation
import SwiftData

@MainActor
final class ChartDataService {
    private enum Constants {
        static let baseURL = URL(string: "https://api.coingecko.com/api/v3/coins")
        static let requestTimeout: TimeInterval = 20
    }

    private let modelContext: ModelContext
    private let session: URLSession

    init(
        modelContext: ModelContext,
        session: URLSession = .shared
    ) {
        self.modelContext = modelContext
        self.session = session
    }

    func fetchChartData(
        for coinID: String,
        vsCurrency: String
    ) async throws -> [ChartData] {
        let normalizedCurrency = vsCurrency.lowercased()

        do {
            let chartData = try await fetchRemoteChartData(
                coinID: coinID,
                currency: normalizedCurrency
            )
            try persist(
                chartData,
                coinID: coinID,
                currency: normalizedCurrency
            )
            return chartData
        } catch {
            let cachedData = try loadCachedChartData(
                coinID: coinID,
                currency: normalizedCurrency
            )

            guard !cachedData.isEmpty else {
                throw error
            }
            return cachedData
        }
    }

    private func fetchRemoteChartData(
        coinID: String,
        currency: String
    ) async throws -> [ChartData] {
        guard let baseURL = Constants.baseURL else {
            throw CryptoServiceError.invalidURL
        }

        let endpoint = baseURL
            .appendingPathComponent(coinID)
            .appendingPathComponent("market_chart")

        guard var components = URLComponents(
            url: endpoint,
            resolvingAgainstBaseURL: false
        ) else {
            throw CryptoServiceError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: currency),
            URLQueryItem(name: "days", value: "365")
        ]

        guard let url = components.url else {
            throw CryptoServiceError.invalidURL
        }

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
            break
        case 429:
            throw CryptoServiceError.rateLimited
        default:
            throw CryptoServiceError.httpStatus(httpResponse.statusCode)
        }

        let history = try JSONDecoder().decode(
            ChartHistoryResponse.self,
            from: data
        )

        return history.prices.compactMap { values in
            guard values.count >= 2 else { return nil }
            return ChartData(
                date: Date(timeIntervalSince1970: values[0] / 1_000),
                price: values[1]
            )
        }
    }

    private func persist(
        _ chartData: [ChartData],
        coinID: String,
        currency: String
    ) throws {
        let existingData = try fetchEntities(
            coinID: coinID,
            currency: currency
        )
        existingData.forEach(modelContext.delete)

        for dataPoint in chartData {
            modelContext.insert(
                ChartDataEntity(
                    from: dataPoint,
                    coinID: coinID,
                    currency: currency
                )
            )
        }

        try modelContext.save()
    }

    private func loadCachedChartData(
        coinID: String,
        currency: String
    ) throws -> [ChartData] {
        try fetchEntities(coinID: coinID, currency: currency)
            .map { $0.toDomain() }
    }

    private func fetchEntities(
        coinID: String,
        currency: String
    ) throws -> [ChartDataEntity] {
        let predicate = #Predicate<ChartDataEntity> { entity in
            entity.coinID == coinID && entity.currency == currency
        }
        let descriptor = FetchDescriptor<ChartDataEntity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\ChartDataEntity.date)]
        )
        return try modelContext.fetch(descriptor)
    }
}
