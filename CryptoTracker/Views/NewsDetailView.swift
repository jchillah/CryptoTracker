//
//  NewsDetailView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct NewsDetailView: View {
    let article: NewsArticle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(article.title)
                    .font(.largeTitle.bold())

                if let imageURL = article.urlToImage.flatMap(URL.init(string:)) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            EmptyView()
                        default:
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 160)
                        }
                    }
                    .clipShape(.rect(cornerRadius: 12))
                }

                if let description = article.description,
                   !description.isEmpty {
                    Text(description)
                        .font(.body)
                }

                HStack {
                    Text(article.source.name)
                    Spacer()
                    Text(article.publishedAt, format: .dateTime.day().month().year())
                }
                .font(.footnote)
                .foregroundStyle(.secondary)

                if let url = URL(string: article.url) {
                    Link(destination: url) {
                        Label("Originalartikel öffnen", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NewsDetailView(
            article: NewsArticle(
                source: .init(id: nil, name: "CoinDesk"),
                author: "CoinDesk",
                title: "Bitcoin market update",
                description: "A concise example article for the SwiftUI preview.",
                url: "https://www.coindesk.com/",
                urlToImage: nil,
                publishedAt: .now,
                content: nil
            )
        )
    }
}
