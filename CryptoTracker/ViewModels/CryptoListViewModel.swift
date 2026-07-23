//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation
import SwiftData

@MainActor
final class CryptoListViewModel: ObservableObject {
    @Published private(set) var lastUpdate: Date?
    @Published private(set) var coins: [Crypto] = []
    @Published private(set) var statusMessage = "Laden…"
    @Published var selectedCurrency = "usd" {
        didSet { applyConversionRate() }
    }

    private enum Constants {
        static let baseCurrency = "usd"
        static let refreshInterval: TimeInterval = 60
    }

    private let service: CryptoService
    private var lastFetchedAt: Date?
    private var originalCoins: [Crypto] = []
    private var refreshTask: Task<Void, Never>?

    var allOriginalCoins: [Crypto] {
        originalCoins
    }

    init(modelContext: ModelContext) {
        service = CryptoService(modelContext: modelContext)

        refreshTask = Task { [weak self] in
            await self?.initialize()
        }
    }

    deinit {
        refreshTask?.cancel()
    }

    func conversionFactor(for currency: String) -> Double {
        let baseRate = service.getConversionRate(for: Constants.baseCurrency)
        let targetRate = service.getConversionRate(for: currency)
        guard baseRate > 0 else { return 1 }
        return targetRate / baseRate
    }

    func fetchCoins(force: Bool = false) async {
        guard force || shouldFetch else {
            applyConversionRate()
            return
        }

        statusMessage = "Laden…"

        do {
            let result = try await service.fetchCryptoData(for: Constants.baseCurrency)
            originalCoins = result.coins
            lastFetchedAt = .now
            lastUpdate = .now
            applyConversionRate()

            switch result.source {
            case .remote:
                statusMessage = "Daten aktualisiert: \(formattedLastUpdate)"
            case .cache:
                statusMessage = "Offline-Daten geladen: \(formattedLastUpdate)"
            }
        } catch {
            statusMessage = "Fehler beim Laden: \(error.localizedDescription)"
        }
    }

    func fetchExchangeRates() async {
        do {
            try await service.fetchExchangeRates()
            applyConversionRate()
        } catch {
            statusMessage = "Wechselkurse konnten nicht aktualisiert werden. Preise werden in USD angezeigt."
        }
    }

    func applyConversionRate() {
        let factor = conversionFactor(for: selectedCurrency)

        coins = originalCoins.map { coin in
            Crypto(
                id: coin.id,
                symbol: coin.symbol,
                name: coin.name,
                image: coin.image,
                currentPrice: coin.currentPrice * factor,
                marketCap: coin.marketCap * factor,
                marketCapRank: coin.marketCapRank,
                volume: coin.volume * factor,
                high24h: coin.high24h * factor,
                low24h: coin.low24h * factor,
                priceChange24h: coin.priceChange24h * factor,
                priceChangePercentage24h: coin.priceChangePercentage24h,
                lastUpdated: coin.lastUpdated
            )
        }
    }

    func formattedPrice(for coin: Crypto) -> String {
        CurrencyFormatter.formatPrice(
            coin.currentPrice,
            currencyCode: selectedCurrency.uppercased()
        )
    }

    private var shouldFetch: Bool {
        guard let lastFetchedAt else { return true }
        return Date().timeIntervalSince(lastFetchedAt) >= Constants.refreshInterval
    }

    private var formattedLastUpdate: String {
        DateFormatterUtil.formatDateToGermanStyle(lastUpdate ?? .now)
    }

    private func initialize() async {
        await fetchExchangeRates()
        await fetchCoins(force: true)

        while !Task.isCancelled {
            do {
                try await Task.sleep(
                    nanoseconds: UInt64(Constants.refreshInterval * 1_000_000_000)
                )
            } catch {
                return
            }

            await fetchCoins(force: true)
        }
    }
}
