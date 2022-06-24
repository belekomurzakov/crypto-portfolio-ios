import Foundation
import Combine
import CoreData

class PriceListViewModel: ObservableObject {
    @Published var allCryptos: [Coin] = []
    @Published var portfolioCryptos: [Coin] = []
    @Published var portfolioCryptosLines: [Double] = []
    @Published var charDataList = [("",0.0)]
    
    var sumOfPortfolio: Double = 0.0
    var total: Double = 0.0
    var charDataListPrior = [("",0.0)]
    
    private let portfolioService = PortfolioService()
    private var cancellables  = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        DataService.shared.$allCryptos
            .sink { [weak self] returnedCryptos in
                self?.allCryptos = returnedCryptos
            }
            .store(in: &cancellables)
        
        $allCryptos
            .combineLatest(portfolioService.$savedEntities)
            .map { (cryptos, portfolioEntities) -> [Coin] in
                cryptos
                    .compactMap { (crypto) -> Coin? in
                        guard let entity = portfolioEntities.first(where: { $0.cryptoId == crypto.id && $0.amount > 0}) else {
                            return nil
                        }
                        let result = crypto.updateHoldings(amount: entity.amount)
                        
                        self.portfolioCryptosLines.append(result.currentHoldingsValue)
                        self.charDataListPrior.append((result.symbol.uppercased(), result.currentHoldingsValue))
                        self.total += result.currentHoldingsValue
                        
                        return result
                    }
            }
            .sink { [weak self] (returnedCryptos) in
                self?.portfolioCryptos = returnedCryptos
                self?.charDataList = self?.charDataListPrior ?? [("",0.0)]
                self?.sumOfPortfolio = self?.total ?? 0.0
                
                self?.total = 0.0
                self?.charDataListPrior = [("",0.0)]
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(crypto: Coin, amount: Double, isPurchased: Bool) {
        portfolioService.updatePortfolio(crypto: crypto, amount: amount, isPurchased: isPurchased)
    }
    
    func getCurrentHolding(cryptoId: String) -> Double {
        var result: Double = 0.0
        
        $portfolioCryptos.map{ coin in
            coin.first(where: { $0.id == cryptoId})
        }
        .sink{ (coin) in
            result = coin?.currentHoldingsValue ?? 0.0
        }
        .store(in: &cancellables)
        
        return result
    }
}
