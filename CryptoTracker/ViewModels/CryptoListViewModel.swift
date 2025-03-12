
import Foundation

@MainActor
class CryptoListViewModel: ObservableObject {
    @Published var coins: [Crypto] = []
    @Published var statusMessage: String = "Laden…"
    @Published var selectedCurrency: String = "usd" {
        didSet {
            applyConversionRate()
        }
    }
    
    private let baseCurrency: String = "usd"
    private let service = CryptoService()
    private var lastFetchedAt: Date? = nil
    private var originalCoins: [Crypto] = []
    private let throttleInterval: TimeInterval = 60
    
    init() {
        Task {
            await fetchExchangeRates()
            await fetchCoins()
        }
    }
    
    func fetchCoins() async {
        guard shouldFetch() else {
            statusMessage = "Daten aus dem Cache verwendet."
            applyConversionRate()
            return
        }
        
        do {
            statusMessage = "Laden…"
            let fetchedCoins = try await service.fetchCryptoData(for: baseCurrency)
            originalCoins = fetchedCoins
            coins = fetchedCoins
            lastFetchedAt = Date()
            statusMessage = "Daten aktualisiert."
        } catch {
            statusMessage = "Fehler beim Laden der Daten: \(error.localizedDescription)"
        }
    }
    
    func fetchExchangeRates() async {
        do {
            try await service.fetchExchangeRates()
        } catch {
            print("Fehler beim Abrufen der Wechselkurse: \(error)")
        }
    }
    
    private func applyConversionRate() {
        let baseRate = service.getConversionRate(for: baseCurrency)
        let targetRate = service.getConversionRate(for: selectedCurrency)
        let conversionFactor = targetRate / baseRate
        
        coins = originalCoins.map { coin in
            return Crypto(
                id: coin.id,
                symbol: coin.symbol,
                name: coin.name,
                image: coin.image,
                currentPrice: coin.currentPrice * conversionFactor,
                marketCap: coin.marketCap * conversionFactor,
                marketCapRank: coin.marketCapRank,
                volume: coin.volume * conversionFactor,
                high24h: coin.high24h * conversionFactor,
                low24h: coin.low24h * conversionFactor,
                priceChange24h: coin.priceChange24h * conversionFactor,
                priceChangePercentage24h: coin.priceChangePercentage24h,
                lastUpdated: coin.lastUpdated
            )
        }
    }
    
    func formattedPrice(for coin: Crypto) -> String {
        return formatPrice(
            coin.currentPrice,
            currencyCode: selectedCurrency.uppercased()
        )
    }
    
    private func shouldFetch() -> Bool {
        if let lastFetch = lastFetchedAt {
            return Date().timeIntervalSince(lastFetch) > throttleInterval
        }
        return true
    }
}
