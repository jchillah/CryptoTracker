//
//  MainView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftData
import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            CryptoListView()
                .tabItem {
                    Label("Top Coins", systemImage: "bitcoinsign.circle.fill")
                }

            FavoritesView()
                .tabItem {
                    Label("Favoriten", systemImage: "star.fill")
                }

            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Einstellungen", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Schema([CryptoEntity.self, ChartDataEntity.self]),
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    MainView()
        .environmentObject(AuthViewModel())
        .environmentObject(
            CryptoListViewModel(modelContext: container.mainContext)
        )
        .environmentObject(FavoritesViewModel())
        .environmentObject(SettingsViewModel())
        .modelContainer(container)
}
