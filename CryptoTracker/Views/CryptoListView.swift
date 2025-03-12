//
//  CryptoListView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct CryptoListView: View {
    @StateObject private var viewModel = CryptoListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.coins) { coin in
                NavigationLink(destination: CryptoDetailView(coin: coin)) {
                    HStack {
                        Text(coin.name)
                        Spacer()
                        Text("$\(coin.price, specifier: "%.2f")")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Top Coins")
            .onAppear {
                viewModel.fetchCoins()
            }
        }
    }
}

#Preview {
    CryptoListView()
}
