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
                    .font(.largeTitle)
                    .bold()
                if let imageUrl = article.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                }
                if let description = article.description {
                    Text(description)
                        .font(.body)
                }
                Text("Veröffentlicht am: \(article.publishedAt, formatter: dateFormatter)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Link("Weiterlesen", destination: URL(string: article.url)!)
                    .font(.headline)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("News Details")
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    let sampleArticle = NewsArticle(
        id: "1",
        title: "Beispiel-News-Titel",
        description: "Dies ist eine Beispielbeschreibung für einen News-Artikel.",
        url: "https://www.example.com",
        publishedAt: Date(),
        imageUrl: nil
    )
    NewsDetailView(article: sampleArticle)
}
