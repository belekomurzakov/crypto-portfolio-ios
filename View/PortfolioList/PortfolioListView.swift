import SwiftUI

struct PortfolioListView: View {
    @EnvironmentObject private var priceListViewModel: PriceListViewModel

    var body: some View {
        NavigationView {
            allCryptosList
                .listStyle(PlainListStyle())
                .navigationTitle("Portfolio value")
        }
    }
}

struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView().environmentObject(dev.priceListViewModel)
    }
}

extension PortfolioListView {
    
    private var allCryptosList: some View {
        List {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 330, height: 190)
                    .foregroundColor(.white)
                Text("\(priceListViewModel.sumOfPortfolio.asCurrencyWith6Decimal())")
                    .font(.title)
                    .frame(alignment: .center)
            }
            .padding()
            .listRowSeparator(.hidden)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(Color.gray, lineWidth: 0.8)
                    .frame(width: 370, height: 200)
            )
            
            ForEach(priceListViewModel.portfolioCryptos) { crypto in
                NavigationLink {
                    FormAssetView(coin: crypto, isPurchase: false)
                        .environmentObject(priceListViewModel)
                } label: {
                    RowCryptoView(showColumnHolding: true, showColumnHistory: false, coin: crypto)
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(Color.gray, lineWidth: 0.8)
                    .frame(width: 370, height: 64)
            )
        }
    }
    
    private var backgroundRectangle: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(width: 321, height: 64)
    }
}
