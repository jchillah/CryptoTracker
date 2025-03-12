//
//  NewsService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

class NewsService {
    // Dummy-API-Endpunkt – bitte ggf. anpassen oder einen echten API-Key verwenden
    private let newsAPIURL = "https://api.example.com/crypto/news"
    
    func fetchNews() async throws -> [NewsArticle] {
        guard let url = URL(string: newsAPIURL) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([NewsArticle].self, from: data)
    }
}
