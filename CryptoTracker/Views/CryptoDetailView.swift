//
//  CryptoDetailView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct CryptoDetailView: View {
    let coin: Crypto
    /// Optional: Falls eine spezifische Währung (z.B. aus der Favoritenansicht) übergeben wird.
    var currency: String? = nil
    /// Steuert, ob die Umrechnung angewendet werden soll. Standardmäßig false.
    var applyConversion: Bool = false
    @EnvironmentObject var viewModel: CryptoListViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        // Erstelle hier das Detail-ViewModel basierend auf dem Environment-ViewModel.
        let detailVM = CryptoDetailViewModel(coin: coin, viewModel: viewModel, currency: currency, applyConversion: applyConversion)
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Preis: \(formatPrice(detailVM.effectivePrice, currencyCode: detailVM.effectiveCurrency.uppercased()))")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("Marktkapitalisierung: \(formatPrice(detailVM.effectiveMarketCap, currencyCode: detailVM.effectiveCurrency.uppercased()))")
                    .font(.body)
                Text("24-Stunden-Handelsvolumen: \(formatPrice(detailVM.effectiveVolume, currencyCode: detailVM.effectiveCurrency.uppercased()))")
                    .font(.body)
                Text("24h Preisänderung: \(coin.priceChangePercentage24h, specifier: "%.2f")%")
                    .foregroundColor(coin.priceChangePercentage24h >= 0 ? .green : .red)
                    .font(.body)
                Text("24-Stunden-Höchstpreis: \(formatPrice(detailVM.effectiveHigh24h, currencyCode: detailVM.effectiveCurrency.uppercased()))")
                Text("24-Stunden-Tiefstpreis: \(formatPrice(detailVM.effectiveLow24h, currencyCode: detailVM.effectiveCurrency.uppercased()))")
                
                Button(action: {
                    favoritesManager.toggleFavorite(coin: coin)
                }) {
                    HStack {
                        Image(systemName: favoritesManager.isFavorite(coin: coin) ? "star.fill" : "star")
                        Text(favoritesManager.isFavorite(coin: coin) ? "Aus Favoriten entfernen" : "Zu Favoriten hinzufügen")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle(coin.name)
    }
}

#Preview {
    let sampleCrypto = Crypto(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        currentPrice: 76797,
        marketCap: 1510872859579,
        marketCapRank: 1,
        volume: 221212,
        high24h: 77286,
        low24h: 72691,
        priceChange24h: 2291.17,
        priceChangePercentage24h: 3.07518,
        lastUpdated: "2025-03-12T13:36:39.814Z"
    )
    // Vorschau für Detailansicht in Favoritensicht (applyConversion: true, da hier Originalwerte in USD vorliegen)
    CryptoDetailView(coin: sampleCrypto, currency: "eur", applyConversion: true)
        .environmentObject(CryptoListViewModel())
        .environmentObject(FavoritesManager())
}

//struct CryptoDetailView: View {
//    let coin: Crypto
//    /// Optional: Falls eine spezifische Währung (z.B. aus der Favoritenansicht) übergeben wird.
//    var currency: String? = nil
//    /// Steuert, ob die Umrechnung angewendet werden soll. Standardmäßig false.
//    var applyConversion: Bool = false
//    @EnvironmentObject var viewModel: CryptoListViewModel
//    @EnvironmentObject var favoritesManager: FavoritesManager
//
//    /// Ermittelt die effektive Währung: Entweder der übergebene Wert oder die im ViewModel ausgewählte
//    var effectiveCurrency: String {
//        currency ?? viewModel.selectedCurrency
//    }
//    
//    /// Berechnet den Umrechnungsfaktor von USD zur effektiven Währung
//    var conversionFactor: Double {
//        viewModel.conversionFactor(for: effectiveCurrency)
//    }
//    
//    /// Berechnet den anzuzeigenden Preis
//    var effectivePrice: Double {
//        applyConversion ? coin.currentPrice * conversionFactor : coin.currentPrice
//    }
//    
//    var effectiveMarketCap: Double {
//        applyConversion ? coin.marketCap * conversionFactor : coin.marketCap
//    }
//    
//    var effectiveVolume: Double {
//        applyConversion ? coin.volume * conversionFactor : coin.volume
//    }
//    
//    var effectiveHigh24h: Double {
//        applyConversion ? coin.high24h * conversionFactor : coin.high24h
//    }
//    
//    var effectiveLow24h: Double {
//        applyConversion ? coin.low24h * conversionFactor : coin.low24h
//    }
//    
//    var body: some View {
//        ScrollView {/Users/jchillah/projects/xcode/CryptoTracker/CryptoTracker/Views/CryptoDetailView.swift
//            VStack(alignment: .leading, spacing: 20) {
//                Text("Preis: \(formatPrice(effectivePrice, currencyCode: effectiveCurrency.uppercased()))")
//                    .font(.title2)
//                    .foregroundColor(.gray)
//                Text("Marktkapitalisierung: \(formatPrice(effectiveMarketCap, currencyCode: effectiveCurrency.uppercased()))")
//                    .font(.body)
//                Text("24-Stunden-Handelsvolumen: \(formatPrice(effectiveVolume, currencyCode: effectiveCurrency.uppercased()))")
//                    .font(.body)
//                Text("24h Preisänderung: \(coin.priceChangePercentage24h, specifier: "%.2f")%")
//                    .foregroundColor(coin.priceChangePercentage24h >= 0 ? .green : .red)
//                    .font(.body)
//                Text("24-Stunden-Höchstpreis: \(formatPrice(effectiveHigh24h, currencyCode: effectiveCurrency.uppercased()))")
//                Text("24-Stunden-Tiefstpreis: \(formatPrice(effectiveLow24h, currencyCode: effectiveCurrency.uppercased()))")
//                
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
//    // Vorschau für Detailansicht in Favoritensicht (applyConversion: true, da hier Originalwerte in USD vorliegen)
//    CryptoDetailView(coin: sampleCrypto, currency: "eur", applyConversion: true)
//        .environmentObject(CryptoListViewModel())
//        .environmentObject(FavoritesManager())
//}

//struct CryptoDetailView: View {
//    let coin: Crypto
//    var currency: String? = nil
//    @EnvironmentObject var viewModel: CryptoListViewModel
//    @EnvironmentObject var favoritesManager: FavoritesManager
//    
//    var effectiveCurrency: String {
//        currency ?? viewModel.selectedCurrency
//    }
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                Text("Preis: \(formatPrice(coin.currentPrice, currencyCode: effectiveCurrency.uppercased()))")
//                    .font(.title2)
//                    .foregroundColor(.gray)
//                Text("Marktkapitalisierung: \(formatPrice(coin.marketCap, currencyCode: effectiveCurrency.uppercased()))")
//                    .font(.body)
//                Text("24-Stunden-Handelsvolumen: \(formatPrice(coin.volume, currencyCode: effectiveCurrency.uppercased()))")
//                    .font(.body)
//                Text("24h Preisänderung: \(coin.priceChangePercentage24h, specifier: "%.2f")%")
//                    .foregroundColor(coin.priceChangePercentage24h >= 0 ? .green : .red)
//                    .font(.body)
//                Text("24-Stunden-Höchstpreis: \(formatPrice(coin.high24h, currencyCode: effectiveCurrency.uppercased()))")
//                Text("24-Stunden-Tiefstpreis: \(formatPrice(coin.low24h, currencyCode: effectiveCurrency.uppercased()))")
//                
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
//    CryptoDetailView(coin: sampleCrypto, currency: "eur")
//        .environmentObject(CryptoListViewModel())
//        .environmentObject(FavoritesManager())
//
//}
