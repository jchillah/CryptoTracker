//
//  CryptoDetailViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

@MainActor
class CryptoDetailViewModel: ObservableObject {
    let coin: Crypto
    let effectiveCurrency: String
    let applyConversion: Bool
    let conversionFactor: Double

    init(coin: Crypto, viewModel: CryptoListViewModel, currency: String? = nil, applyConversion: Bool = false) {
        self.coin = coin
        self.effectiveCurrency = currency ?? viewModel.selectedCurrency
        self.applyConversion = applyConversion
        self.conversionFactor = viewModel.conversionFactor(for: self.effectiveCurrency)
    }
    
    var effectivePrice: Double {
        applyConversion ? coin.currentPrice * conversionFactor : coin.currentPrice
    }
    
    var effectiveMarketCap: Double {
        applyConversion ? coin.marketCap * conversionFactor : coin.marketCap
    }
    
    var effectiveVolume: Double {
        applyConversion ? coin.volume * conversionFactor : coin.volume
    }
    
    var effectiveHigh24h: Double {
        applyConversion ? coin.high24h * conversionFactor : coin.high24h
    }
    
    var effectiveLow24h: Double {
        applyConversion ? coin.low24h * conversionFactor : coin.low24h
    }
}
