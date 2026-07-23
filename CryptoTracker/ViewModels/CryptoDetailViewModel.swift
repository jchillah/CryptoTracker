//
//  CryptoDetailViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

@MainActor
struct CryptoDetailViewModel {
    let coin: Crypto
    let applyConversion: Bool

    private let parentViewModel: CryptoListViewModel
    private let fixedCurrency: String?

    init(
        coin: Crypto,
        viewModel: CryptoListViewModel,
        currency: String? = nil,
        applyConversion: Bool = false
    ) {
        self.coin = coin
        parentViewModel = viewModel
        fixedCurrency = currency
        self.applyConversion = applyConversion
    }

    var effectiveCurrency: String {
        fixedCurrency ?? parentViewModel.selectedCurrency
    }

    var effectivePrice: Double {
        converted(coin.currentPrice)
    }

    var effectiveMarketCap: Double {
        converted(coin.marketCap)
    }

    var effectiveVolume: Double {
        converted(coin.volume)
    }

    var effectiveHigh24h: Double {
        converted(coin.high24h)
    }

    var effectiveLow24h: Double {
        converted(coin.low24h)
    }

    private var conversionFactor: Double {
        parentViewModel.conversionFactor(for: effectiveCurrency)
    }

    private func converted(_ value: Double) -> Double {
        applyConversion ? value * conversionFactor : value
    }
}
