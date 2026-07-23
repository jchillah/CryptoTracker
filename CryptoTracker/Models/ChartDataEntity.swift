//
//  ChartDataEntity.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 19.03.25.
//

import Foundation
import SwiftData

@Model
final class ChartDataEntity: Identifiable {
    @Attribute(.unique) var id: UUID
    var coinID: String = ""
    var currency: String = "usd"
    var date: Date
    var price: Double

    init(
        from chartData: ChartData,
        coinID: String,
        currency: String
    ) {
        id = UUID()
        self.coinID = coinID
        self.currency = currency.lowercased()
        date = chartData.date
        price = chartData.price
    }

    func toDomain() -> ChartData {
        ChartData(date: date, price: price)
    }
}
