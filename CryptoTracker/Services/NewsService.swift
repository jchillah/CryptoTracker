//
//  NewsService.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 12.03.25.
//

import Foundation

enum NewsServiceError: LocalizedError {
    case invalidResponse
    case httpStatus(Int)
    case invalidFeed

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Der News-Server hat keine gültige Antwort geliefert."
        case .httpStatus(let statusCode):
            return "Die News-Anfrage ist mit HTTP-Status \(statusCode) fehlgeschlagen."
        case .invalidFeed:
            return "Der News-Feed konnte nicht verarbeitet werden."
        }
    }
}

final class NewsService {
    private enum Constants {
        static let feedURL = URL(string: "https://www.coindesk.com/arc/outboundfeeds/rss/")!
        static let requestTimeout: TimeInterval = 20
    }

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchNews() async throws -> [NewsArticle] {
        var request = URLRequest(url: Constants.feedURL)
        request.timeoutInterval = Constants.requestTimeout
        request.cachePolicy = .returnCacheDataElseLoad
        request.setValue("application/rss+xml, application/xml", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NewsServiceError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NewsServiceError.httpStatus(httpResponse.statusCode)
        }

        return try await Task.detached(priority: .userInitiated) {
            try RSSFeedParser.parse(data)
        }.value
    }
}

private enum RSSFeedParser {
    static func parse(_ data: Data) throws -> [NewsArticle] {
        let delegate = RSSParserDelegate()
        let parser = XMLParser(data: data)
        parser.delegate = delegate

        guard parser.parse() else {
            throw parser.parserError ?? NewsServiceError.invalidFeed
        }

        return delegate.articles
    }
}

private final class RSSParserDelegate: NSObject, XMLParserDelegate {
    private(set) var articles: [NewsArticle] = []

    private var isInsideItem = false
    private var currentElement = ""
    private var currentValue = ""

    private var title = ""
    private var link = ""
    private var articleDescription: String?
    private var author: String?
    private var imageURL: String?
    private var publishedAt = Date()

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        let name = qName ?? elementName
        currentElement = name
        currentValue = ""

        if elementName == "item" {
            resetCurrentItem()
            isInsideItem = true
        }

        if isInsideItem,
           (name == "media:content" || name == "media:thumbnail"),
           let url = attributeDict["url"] {
            imageURL = url
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard isInsideItem else { return }
        currentValue += string
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        guard isInsideItem else { return }

        let name = qName ?? elementName
        let value = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)

        switch name {
        case "title":
            title = value
        case "link":
            link = value
        case "description":
            articleDescription = value.cleanedHTML
        case "dc:creator", "author":
            author = value.isEmpty ? nil : value
        case "pubDate":
            publishedAt = Self.date(from: value) ?? .now
        case "item":
            appendCurrentArticle()
            isInsideItem = false
        default:
            break
        }

        currentElement = ""
        currentValue = ""
    }

    private func appendCurrentArticle() {
        guard !title.isEmpty, !link.isEmpty else { return }

        articles.append(
            NewsArticle(
                source: .init(id: nil, name: "CoinDesk"),
                author: author,
                title: title.cleanedHTML,
                description: articleDescription,
                url: link,
                urlToImage: imageURL,
                publishedAt: publishedAt,
                content: nil
            )
        )
    }

    private func resetCurrentItem() {
        title = ""
        link = ""
        articleDescription = nil
        author = nil
        imageURL = nil
        publishedAt = .now
    }

    private static func date(from value: String) -> Date? {
        let formats = [
            "EEE, dd MMM yyyy HH:mm:ss Z",
            "EEE, dd MMM yyyy HH:mm Z",
            "dd MMM yyyy HH:mm:ss Z"
        ]

        for format in formats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = format
            if let date = formatter.date(from: value) {
                return date
            }
        }

        return ISO8601DateFormatter().date(from: value)
    }
}

private extension String {
    var cleanedHTML: String {
        replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
        .replacingOccurrences(of: "&amp;", with: "&")
        .replacingOccurrences(of: "&quot;", with: "\"")
        .replacingOccurrences(of: "&#39;", with: "'")
        .replacingOccurrences(of: "&nbsp;", with: " ")
        .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
