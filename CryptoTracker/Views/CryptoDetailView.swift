//
//  CryptoDetailView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct CryptoDetailView: View {
    let coin: Crypto
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(coin.name)
                    .font(.largeTitle)
                    .bold()
                Text("Preis: $\(coin.price, specifier: "%.2f")")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("Marktkapitalisierung: $\(coin.marketCap, specifier: "%.2f")")
                    .font(.body)
                Text("24-Stunden-Handelsvolumen: $\(coin.volume, specifier: "%.2f")")
                    .font(.body)
                Text("24h Preisänderung: \(coin.priceChangePercentage24h, specifier: "%.2f")%")
                    .foregroundColor(coin.priceChangePercentage24h >= 0 ? .green : .red)
                    .font(.body)
                Text("24-Stunden-Höchstpreis: $\(coin.high24h, specifier: "%.2f")")
                Text("24-Stunden-Tiefstpreis: $\(coin.low24h, specifier: "%.2f")")
            }
            .padding()
        }
        .navigationTitle(coin.name)
    }
}

#Preview {
    let sampleCrypto = Crypto(
        id: "bitcoin",
        name: "Bitcoin",
        symbol: "BTC",
        price: 45000.00,
        marketCap: 850000000000,
        volume: 35000000,
        priceChangePercentage24h: 3.5,
        high24h: 46000.00,
        low24h: 44000.00
    )
    CryptoDetailView(coin: sampleCrypto)
}
