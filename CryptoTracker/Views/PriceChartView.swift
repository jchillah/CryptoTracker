//
//  PriceChartView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Charts
import SwiftData
import SwiftUI

struct PriceChartView: View {
    @StateObject private var viewModel: PriceChartViewModel

    let coinID: String
    let currency: String

    @State private var selectedDuration: ChartDuration = .week

    init(
        coinId: String,
        vsCurrency: String,
        modelContext: ModelContext
    ) {
        coinID = coinId
        currency = vsCurrency.lowercased()
        _viewModel = StateObject(
            wrappedValue: PriceChartViewModel(modelContext: modelContext)
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            Picker("Zeitraum", selection: $selectedDuration) {
                ForEach(ChartDuration.allCases) { duration in
                    Text(duration.rawValue).tag(duration)
                }
            }
            .pickerStyle(.segmented)
            .accessibilityIdentifier("chartDurationPicker")

            chartContent
        }
        .task(id: "\(coinID)-\(currency)") {
            await viewModel.fetchPriceHistory(
                for: coinID,
                currency: currency
            )
        }
    }

    @ViewBuilder
    private var chartContent: some View {
        if viewModel.isLoading {
            ProgressView("Chart wird geladen…")
                .frame(maxWidth: .infinity, minHeight: 200)
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView(
                "Chart nicht verfügbar",
                systemImage: "chart.xyaxis.line",
                description: Text(errorMessage)
            )
            .frame(minHeight: 200)
        } else {
            let filteredData = viewModel.filteredData(for: selectedDuration)

            if filteredData.isEmpty {
                ContentUnavailableView(
                    "Keine Chartdaten",
                    systemImage: "chart.xyaxis.line",
                    description: Text("Für den gewählten Zeitraum sind keine Daten verfügbar.")
                )
                .frame(minHeight: 200)
            } else {
                Chart(filteredData) { dataPoint in
                    LineMark(
                        x: .value("Datum", dataPoint.date),
                        y: .value("Preis", dataPoint.price)
                    )
                    .interpolationMethod(.catmullRom)
                }
                .chartYAxisLabel(currency.uppercased())
                .frame(height: 220)
                .accessibilityLabel("Preisverlauf in \(currency.uppercased())")
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Schema([CryptoEntity.self, ChartDataEntity.self]),
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    PriceChartView(
        coinId: "bitcoin",
        vsCurrency: "usd",
        modelContext: container.mainContext
    )
    .padding()
    .modelContainer(container)
}
