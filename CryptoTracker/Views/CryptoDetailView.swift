//
//  CryptoDetailView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct CryptoDetailView: View {
    let coin: Crypto
    @EnvironmentObject var viewModel: CryptoListViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(coin.name)
                    .font(.largeTitle)
                    .bold()
                Text("Preis: \(formatPrice(coin.currentPrice, currencyCode: viewModel.selectedCurrency.uppercased()))")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("Marktkapitalisierung: \(formatPrice(coin.marketCap, currencyCode: viewModel.selectedCurrency.uppercased()))")
                    .font(.body)
                Text("24-Stunden-Handelsvolumen: \(formatPrice(coin.volume, currencyCode: viewModel.selectedCurrency.uppercased()))")
                    .font(.body)
                Text("24h Preisänderung: \(coin.priceChangePercentage24h, specifier: "%.2f")%")
                    .foregroundColor(coin.priceChangePercentage24h >= 0 ? .green : .red)
                    .font(.body)
                Text("24-Stunden-Höchstpreis: \(formatPrice(coin.high24h, currencyCode: viewModel.selectedCurrency.uppercased()))")
                Text("24-Stunden-Tiefstpreis: \(formatPrice(coin.low24h, currencyCode: viewModel.selectedCurrency.uppercased()))")
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
    CryptoDetailView(coin: sampleCrypto)
        .environmentObject(CryptoListViewModel())
}
