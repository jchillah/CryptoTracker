//
//  PriceChartViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation
import SwiftData

@MainActor
final class PriceChartViewModel: ObservableObject {
    @Published private(set) var allPriceData: [ChartData] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service: ChartDataService

    init(modelContext: ModelContext) {
        service = ChartDataService(modelContext: modelContext)
    }

    func fetchPriceHistory(
        for coinID: String,
        currency: String
    ) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            allPriceData = try await service.fetchChartData(
                for: coinID,
                vsCurrency: currency
            )
        } catch {
            allPriceData = []
            errorMessage = error.localizedDescription
        }
    }

    func filteredData(for duration: ChartDuration) -> [ChartData] {
        guard let cutoffDate = Calendar.current.date(
            byAdding: .day,
            value: -duration.days,
            to: .now
        ) else {
            return allPriceData
        }

        return allPriceData.filter { $0.date >= cutoffDate }
    }
}
