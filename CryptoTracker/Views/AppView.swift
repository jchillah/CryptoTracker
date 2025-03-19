//
//  AppView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 17.03.25.
//

import SwiftUI
import SwiftData

struct AppView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var cryptoListViewModel: CryptoListViewModel
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @EnvironmentObject private var favoritesManager: FavoritesManager
    
    var body: some View {
        Group {
            if authViewModel.currentUser == nil {
                AuthView(viewModel: authViewModel)
            } else {
                MainView()
                    .environmentObject(authViewModel)
                    .environmentObject(favoritesViewModel)
                    .environmentObject(cryptoListViewModel)
                    .environmentObject(settingsViewModel)
                    .environmentObject(favoritesManager)
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Schema([CryptoEntity.self, ChartDataEntity.self]))
    AppView()
        .environmentObject(AuthViewModel())
        .environmentObject(FavoritesViewModel())
        .environmentObject(CryptoListViewModel(modelContext: container.mainContext))
        .environmentObject(SettingsViewModel())
        .environmentObject(FavoritesManager())
        .modelContainer(container)
}

