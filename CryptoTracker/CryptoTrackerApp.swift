//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import FirebaseCore
import OSLog
import SwiftData
import SwiftUI

@main
struct CryptoTrackerApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    private let container: ModelContainer

    @StateObject private var authViewModel: AuthViewModel
    @StateObject private var favoritesViewModel: FavoritesViewModel
    @StateObject private var cryptoListViewModel: CryptoListViewModel
    @StateObject private var settingsViewModel: SettingsViewModel
    @StateObject private var priceChartViewModel: PriceChartViewModel

    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        let modelContainer = Self.makeModelContainer()
        container = modelContainer

        _authViewModel = StateObject(wrappedValue: AuthViewModel())
        _favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel())
        _cryptoListViewModel = StateObject(
            wrappedValue: CryptoListViewModel(
                modelContext: modelContainer.mainContext
            )
        )
        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel())
        _priceChartViewModel = StateObject(
            wrappedValue: PriceChartViewModel(
                modelContext: modelContainer.mainContext
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(authViewModel)
                .environmentObject(favoritesViewModel)
                .environmentObject(cryptoListViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(priceChartViewModel)
                .modelContainer(container)
        }
    }

    private static func makeModelContainer() -> ModelContainer {
        let schema = Schema([CryptoEntity.self, ChartDataEntity.self])

        do {
            return try ModelContainer(for: schema)
        } catch {
            Logger.app.error(
                "Persistent model container failed: \(error.localizedDescription, privacy: .public)"
            )

            do {
                return try ModelContainer(
                    for: schema,
                    configurations: ModelConfiguration(
                        isStoredInMemoryOnly: true
                    )
                )
            } catch {
                preconditionFailure(
                    "CryptoTracker could not create a model container: \(error)"
                )
            }
        }
    }
}

private extension Logger {
    static let app = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "CryptoTracker",
        category: "App"
    )
}
