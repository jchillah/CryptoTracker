//
//  NewsViewModel.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    @Published private(set) var articles: [NewsArticle] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let newsService: NewsService
    private var hasLoaded = false

    init(newsService: NewsService = NewsService()) {
        self.newsService = newsService
    }

    func fetchNews(force: Bool = false) async {
        guard force || !hasLoaded else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            articles = try await newsService.fetchNews()
                .sorted { $0.publishedAt > $1.publishedAt }
            hasLoaded = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
