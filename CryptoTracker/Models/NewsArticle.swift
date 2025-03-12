//
//  NewsArticle.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

struct NewsArticle: Identifiable, Decodable {
    let id: String
    let title: String
    let description: String?
    let url: String
    let publishedAt: Date
    let imageUrl: String?
}
