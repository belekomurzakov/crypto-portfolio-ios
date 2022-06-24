import SwiftUI

@main
struct CryptoPortfolioApp: App {
    @StateObject private var viewModel = PriceListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
