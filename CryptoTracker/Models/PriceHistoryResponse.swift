//
//  PriceHistoryResponse.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

struct PriceHistoryResponse: Decodable {
    let prices: [[Double]]
}


