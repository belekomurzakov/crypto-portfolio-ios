import Foundation
import Combine
import CoreData

class HistoryListViewModel: ObservableObject {
    @Published var allCryptos: [Coin] = []
    @Published var activityHistory: [Coin] = []
    @Published var activityHistoryLine: [Double] = []
    
    private let historyService = ActivityHistoryService()
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
        
        historyService.$savedActivityHistory
            .combineLatest($allCryptos)
            .map{ (savedActivityHistory, cryptos) -> [Coin] in
                
                savedActivityHistory
                    .compactMap { (history) -> Coin? in
                        guard let crypto = cryptos.first(where: { $0.id == history.cryptoId}) else {
                            return nil
                        }
                        let coin = crypto.addHistory(amount: history.amount, isPurchased: history.isPurchased)
                        self.activityHistoryLine.append(coin.currentHoldingsValue)
                        return coin
                    }
            }
            .sink { [weak self] (returnedHistory) in
                self?.activityHistory = returnedHistory
            }
            .store(in: &cancellables)
    }
    
    func addHistory(crypto: Coin, amount: Double, isPurchased: Bool) {
        historyService.addHistory(crypto: crypto, amount: amount, isPurchased: isPurchased)
    }
}
