import SwiftUI

struct PriceListView: View {
    @EnvironmentObject private var priceListViewModel: PriceListViewModel
    
    var body: some View {
        NavigationView {
            allCryptosList
                .listStyle(PlainListStyle())
                .navigationTitle("Crypto")
        }
    } 
}

struct PriceListView_Previews: PreviewProvider {
    static var previews: some View {
        PriceListView().environmentObject(dev.priceListViewModel)
    }
}

extension PriceListView {
    
    private var allCryptosList: some View {
        List {
            ForEach(priceListViewModel.allCryptos) { crypto in
                NavigationLink {
                    FormAssetView(coin: crypto, isPurchase: true)
                        .environmentObject(priceListViewModel)
                } label: {
                    RowCryptoView(showColumnHolding: false,showColumnHistory: false, coin: crypto)
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
}
