//
//  CryptoDetailView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct CryptoDetailView: View {
    let coin: Crypto
    let conversionRate: Double
    let currency: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(coin.name)
                    .font(.largeTitle)
                    .bold()
                Text("Preis: \(coin.currentPrice * conversionRate, specifier: "%.2f") \(currency.uppercased())")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("Marktkapitalisierung: \(coin.marketCap * conversionRate, specifier: "%.2f") \(currency.uppercased())")
                    .font(.body)
                Text("24-Stunden-Handelsvolumen: \(coin.volume * conversionRate, specifier: "%.2f") \(currency.uppercased())")
                    .font(.body)
                Text("24h Preisänderung: \(coin.priceChangePercentage24h, specifier: "%.2f")%")
                    .foregroundColor(coin.priceChangePercentage24h >= 0 ? .green : .red)
                    .font(.body)
                Text("24-Stunden-Höchstpreis: \(coin.high24h * conversionRate, specifier: "%.2f") \(currency.uppercased())")
                Text("24-Stunden-Tiefstpreis: \(coin.low24h * conversionRate, specifier: "%.2f") \(currency.uppercased())")
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
    CryptoDetailView(coin: sampleCrypto, conversionRate: 0.91, currency: "eur")
}
