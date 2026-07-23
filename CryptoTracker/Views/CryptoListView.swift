//
//  CryptoListView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftData
import SwiftUI

struct CryptoListView: View {
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cryptoViewModel: CryptoListViewModel

    private let supportedCurrencies = ["usd", "eur", "gbp"]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    updateStatus
                    currencyPicker

                    if cryptoViewModel.coins.isEmpty {
                        ContentUnavailableView(
                            "Keine Marktdaten",
                            systemImage: "chart.line.downtrend.xyaxis",
                            description: Text("Ziehen Sie zum Aktualisieren nach unten.")
                        )
                        .padding(.top, 48)
                    } else {
                        ForEach(cryptoViewModel.coins) { coin in
                            NavigationLink {
                                CryptoDetailView(
                                    coin: coin,
                                    currency: cryptoViewModel.selectedCurrency,
                                    applyConversion: true
                                )
                                .environmentObject(cryptoViewModel)
                                .environmentObject(favoritesViewModel)
                            } label: {
                                CryptoRowView(
                                    coin: coin,
                                    currency: cryptoViewModel.selectedCurrency
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                await cryptoViewModel.fetchCoins(force: true)
            }
            .navigationTitle("Krypto-Preise")
        }
    }

    private var updateStatus: some View {
        VStack(spacing: 4) {
            if let lastUpdate = cryptoViewModel.lastUpdate {
                Text("Update: \(DateFormatterUtil.formatDateToGermanStyle(lastUpdate))")
                    .font(.caption)
            }

            Text(cryptoViewModel.statusMessage)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(statusColor)
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
    }

    private var currencyPicker: some View {
        Picker("Währung", selection: $cryptoViewModel.selectedCurrency) {
            ForEach(supportedCurrencies, id: \.self) { currency in
                Text(currency.uppercased()).tag(currency)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityIdentifier("currencyPicker")
    }

    private var statusColor: Color {
        let message = cryptoViewModel.statusMessage.lowercased()
        return message.contains("fehler") ? .red : .secondary
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Schema([CryptoEntity.self, ChartDataEntity.self]),
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    CryptoListView()
        .environmentObject(CryptoListViewModel(modelContext: container.mainContext))
        .environmentObject(FavoritesViewModel())
        .modelContainer(container)
}
