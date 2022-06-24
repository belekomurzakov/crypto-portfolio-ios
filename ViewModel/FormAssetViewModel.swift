import Foundation
import Combine
import CoreData

class FormAssetViewModel: ObservableObject {    
    @Published var allCryptos: [Coin] = []
    @Published var portfolioCryptos: [Coin] = []
   
    private let portfolioService = PortfolioService()
    
    private let dataService = DataService()
    private var cancellables  = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$allCryptos
            .sink { [weak self] returnedCryptos in
                self?.allCryptos = returnedCryptos
            }
            .store(in: &cancellables)
        
        $allCryptos
            .combineLatest(portfolioService.$savedEntities)
            .map { (cryptos, portfolioEntities) -> [Coin] in
                
                cryptos
                    .compactMap { (crypto) -> Coin? in
                        guard let entity = portfolioEntities.first(where: { $0.cryptoId == crypto.id}) else {
                            return nil
                        }
                        return crypto.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnedCryptos) in
                self?.portfolioCryptos = returnedCryptos
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(crypto: Coin, amount: Double, isPurchased: Bool) {
        portfolioService.updatePortfolio(crypto: crypto, amount: amount, isPurchased: isPurchased)
    }
}
