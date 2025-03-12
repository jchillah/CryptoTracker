//
//  CryptoListView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct CryptoListView: View {
    var body: some View {
        NavigationView {
            List {
                Text("Coin Liste kommt hier")
            }
            .navigationTitle("Top Coins")
        }
    }
}

#Preview {
    CryptoListView()
}
