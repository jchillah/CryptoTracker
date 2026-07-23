//
//  NewsView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    ProgressView("News werden geladen…")
                } else if let errorMessage = viewModel.errorMessage,
                          viewModel.articles.isEmpty {
                    ContentUnavailableView(
                        "News nicht verfügbar",
                        systemImage: "newspaper",
                        description: Text(errorMessage)
                    )
                } else if viewModel.articles.isEmpty {
                    ContentUnavailableView(
                        "Keine News",
                        systemImage: "newspaper",
                        description: Text("Der Feed enthält derzeit keine Beiträge.")
                    )
                } else {
                    List(viewModel.articles) { article in
                        NavigationLink {
                            NewsDetailView(article: article)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(article.title)
                                    .font(.headline)
                                    .lineLimit(3)

                                if let description = article.description,
                                   !description.isEmpty {
                                    Text(description)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                        .foregroundStyle(.secondary)
                                }

                                HStack {
                                    Text(article.source.name)
                                    Spacer()
                                    Text(article.publishedAt, style: .date)
                                }
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.fetchNews(force: true)
                    }
                }
            }
            .navigationTitle("Krypto-News")
            .task {
                await viewModel.fetchNews()
            }
        }
    }
}

#Preview {
    NewsView()
}
