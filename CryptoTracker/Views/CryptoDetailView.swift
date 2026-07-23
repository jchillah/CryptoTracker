//
//  CryptoDetailView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftData
import SwiftUI

struct CryptoDetailView: View {
    let coin: Crypto
    var currency: String?
    var applyConversion = false

    @EnvironmentObject private var marketViewModel: CryptoListViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        let detail = CryptoDetailViewModel(
            coin: coin,
            viewModel: marketViewModel,
            currency: currency,
            applyConversion: applyConversion
        )

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                priceSection(detail)

                PriceChartView(
                    coinId: coin.id,
                    vsCurrency: detail.effectiveCurrency,
                    modelContext: modelContext
                )

                favoriteButton

                if let errorMessage = favoritesViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .accessibilityIdentifier("favoriteErrorMessage")
                }
            }
            .padding()
        }
        .navigationTitle(coin.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func priceSection(
        _ detail: CryptoDetailViewModel
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            metric(
                "Preis",
                value: formatted(detail.effectivePrice, currency: detail.effectiveCurrency),
                prominence: true
            )
            metric(
                "Marktkapitalisierung",
                value: formatted(detail.effectiveMarketCap, currency: detail.effectiveCurrency)
            )
            metric(
                "24-Stunden-Handelsvolumen",
                value: formatted(detail.effectiveVolume, currency: detail.effectiveCurrency)
            )
            metric(
                "24-Stunden-Höchstpreis",
                value: formatted(detail.effectiveHigh24h, currency: detail.effectiveCurrency)
            )
            metric(
                "24-Stunden-Tiefstpreis",
                value: formatted(detail.effectiveLow24h, currency: detail.effectiveCurrency)
            )

            HStack {
                Text("24h Preisänderung")
                Spacer()
                Text(coin.priceChangePercentage24h, format: .number.precision(.fractionLength(2)))
                    + Text(" %")
            }
            .foregroundStyle(
                Color.priceChangeColor(for: coin.priceChangePercentage24h)
            )
        }
        .accessibilityElement(children: .contain)
    }

    private var favoriteButton: some View {
        let isFavorite = favoritesViewModel.isFavorite(coin: coin)

        return Button {
            Task { await favoritesViewModel.toggleFavorite(coin: coin) }
        } label: {
            Label(
                isFavorite
                    ? "Aus Favoriten entfernen"
                    : "Zu Favoriten hinzufügen",
                systemImage: isFavorite ? "star.fill" : "star"
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.borderedProminent)
        .accessibilityIdentifier("favoriteButton")
    }

    private func metric(
        _ title: String,
        value: String,
        prominence: Bool = false
    ) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(prominence ? .headline : .body)
            Spacer()
            Text(value)
                .font(prominence ? .title3.bold() : .body)
                .foregroundStyle(prominence ? .primary : .secondary)
                .multilineTextAlignment(.trailing)
        }
    }

    private func formatted(_ value: Double, currency: String) -> String {
        CurrencyFormatter.formatPrice(
            value,
            currencyCode: currency.uppercased()
        )
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Schema([CryptoEntity.self, ChartDataEntity.self]),
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let sampleCrypto = Crypto(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png",
        currentPrice: 76_797,
        marketCap: 1_510_872_859_579,
        marketCapRank: 1,
        volume: 221_212,
        high24h: 77_286,
        low24h: 72_691,
        priceChange24h: 2_291.17,
        priceChangePercentage24h: 3.07518,
        lastUpdated: "2025-03-12T13:36:39.814Z"
    )

    NavigationStack {
        CryptoDetailView(
            coin: sampleCrypto,
            currency: "eur",
            applyConversion: true
        )
    }
    .environmentObject(
        CryptoListViewModel(modelContext: container.mainContext)
    )
    .environmentObject(FavoritesViewModel())
    .modelContainer(container)
}
