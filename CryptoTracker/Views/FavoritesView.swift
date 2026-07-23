//
//  FavoritesView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftData
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var marketViewModel: CryptoListViewModel

    @State private var favoritesCurrency = "usd"

    private let supportedCurrencies = ["usd", "eur", "gbp"]

    private var favoriteCoins: [Crypto] {
        marketViewModel.allOriginalCoins.filter {
            favoritesViewModel.favoriteIDs.contains($0.id)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoriteCoins.isEmpty {
                    ContentUnavailableView(
                        "Keine Favoriten",
                        systemImage: "star",
                        description: Text("Markieren Sie einen Coin in der Detailansicht als Favorit.")
                    )
                } else {
                    List {
                        Section {
                            currencyPicker
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                        }

                        Section {
                            ForEach(favoriteCoins) { coin in
                                NavigationLink {
                                    CryptoDetailView(
                                        coin: coin,
                                        currency: favoritesCurrency,
                                        applyConversion: true
                                    )
                                    .environmentObject(marketViewModel)
                                    .environmentObject(favoritesViewModel)
                                } label: {
                                    favoriteRow(coin)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favoriten")
            .task {
                await favoritesViewModel.loadFavorites()
            }
            .refreshable {
                await favoritesViewModel.loadFavorites()
            }
            .overlay {
                if favoritesViewModel.isLoading && favoriteCoins.isEmpty {
                    ProgressView()
                }
            }
        }
    }

    private var currencyPicker: some View {
        Picker("Währung", selection: $favoritesCurrency) {
            ForEach(supportedCurrencies, id: \.self) { currency in
                Text(currency.uppercased()).tag(currency)
            }
        }
        .pickerStyle(.segmented)
        .padding(.vertical, 8)
        .accessibilityIdentifier("favoritesCurrencyPicker")
    }

    private func favoriteRow(_ coin: Crypto) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: coin.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "bitcoinsign.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                default:
                    ProgressView()
                }
            }
            .frame(width: 32, height: 32)

            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.headline)
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(formattedPrice(for: coin))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }

    private func formattedPrice(for coin: Crypto) -> String {
        let convertedPrice = coin.currentPrice
            * marketViewModel.conversionFactor(for: favoritesCurrency)

        return CurrencyFormatter.formatPrice(
            convertedPrice,
            currencyCode: favoritesCurrency.uppercased()
        )
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Schema([CryptoEntity.self, ChartDataEntity.self]),
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    FavoritesView()
        .environmentObject(FavoritesViewModel())
        .environmentObject(
            CryptoListViewModel(modelContext: container.mainContext)
        )
        .modelContainer(container)
}
