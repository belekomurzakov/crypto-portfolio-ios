import Foundation
import Combine
import SwiftUI

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let crypto: Coin
    private let coinImageService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(crypto: Coin) {
        self.crypto = crypto
        self.coinImageService = CoinImageService(crypto: crypto)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        coinImageService.$image
            .sink{ [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
