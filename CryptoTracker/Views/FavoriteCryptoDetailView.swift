////
////  FavoriteCryptoDetailView.swift
////  CryptoTracker
////
////  Created by Michael Winkler on 12.03.25.
////
//
//
//import SwiftUI
//
//struct FavoriteCryptoDetailView: View {
//    let coin: Crypto
//    var currency: String? = nil
//    @EnvironmentObject var viewModel: CryptoListViewModel
//    @EnvironmentObject var favoritesManager: FavoritesManager
//    
//    var effectiveCurrency: String {
//        currency ?? viewModel.selectedCurrency
//    }
//    
//    var conversionFactor: Double {
//        viewModel.conversionFactor(for: effectiveCurrency)
//    }
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                Text("Preis: \(formatPrice(coin.currentPrice * conversionFactor, currencyCode: effectiveCurrency.uppercased()))")
//                    .font(.title2)
//                    .fo/*/Users/jchillah/projects/xcode/CryptoTracker/CryptoTracker/Views/FavoriteCryptoDetailView.swift*/regroundColor(.gray)
//                Text("Marktkapitalisierung: \(formatPrice(coin.marketCap * conversionFactor, currencyCode: effectiveCurrency.uppercased()))")
//                    .font(.body)
//                Text("24-Stunden-Handelsvolumen: \(formatPrice(coin.volume * conversionFactor, currencyCode: effectiveCurrency.uppercased()))")
//                    .font(.body)
//                Text("24h Preisänderung: \(coin.priceChangePercentage24h, specifier: "%.2f")%")
//                    .foregroundColor(coin.priceChangePercentage24h >= 0 ? .green : .red)
//                    .font(.body)
//                Text("24-Stunden-Höchstpreis: \(formatPrice(coin.high24h * conversionFactor, currencyCode: effectiveCurrency.uppercased()))")
//                Text("24-Stunden-Tiefstpreis: \(formatPrice(coin.low24h * conversionFactor, currencyCode: effectiveCurrency.uppercased()))")
//                Button(action: {
//                    favoritesManager.toggleFavorite(coin: coin)
//                }) {
//                    HStack {
//                        Image(systemName: favoritesManager.isFavorite(coin: coin) ? "star.fill" : "star")
//                        Text(favoritesManager.isFavorite(coin: coin) ? "Aus Favoriten entfernen" : "Zu Favoriten hinzufügen")
//                    }
//                    .padding()
//                    .background(Color.blue.opacity(0.1))
//                    .cornerRadius(8)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle(coin.name)
//    }
//}
//
//#Preview {
//    let sampleCrypto = Crypto(
//        id: "bitcoin",
//        symbol: "btc",
//        name: "Bitcoin",
//        image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
//        currentPrice: 76797,
//        marketCap: 1510872859579,
//        marketCapRank: 1,
//        volume: 221212,
//        high24h: 77286,
//        low24h: 72691,
//        priceChange24h: 2291.17,
//        priceChangePercentage24h: 3.07518,
//        lastUpdated: "2025-03-12T13:36:39.814Z"
//    )
//    FavoriteCryptoDetailView(coin: sampleCrypto, currency: "eur")
//        .environmentObject(CryptoListViewModel())
//        .environmentObject(FavoritesManager())
//
//}
