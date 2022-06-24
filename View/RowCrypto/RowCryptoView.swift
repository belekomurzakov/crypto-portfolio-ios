import SwiftUI

struct RowCryptoView: View {
    
    var showColumnHolding: Bool
    var showColumnHistory: Bool
    let coin: Coin
    
    var body: some View {
        HStack {
            leftColumn
            Spacer()
            if showColumnHolding {
                rightColumnHolding
            } else if showColumnHistory {
                rightColumnHistory
            } else {
                rightColumnPrice
            }
        }
        .font(.subheadline)
    }
}

struct RowCryptoView_Previews: PreviewProvider {
    static var previews: some View {
        RowCryptoView(showColumnHolding: false, showColumnHistory: false, coin: dev.coin)
            .previewLayout(.sizeThatFits)
    }
}

extension RowCryptoView {
    
    private var leftColumn: some View {
        HStack{
            CoinImageView(crypto: coin)
                .frame(width: 30, height: 30)
                .padding()
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
        }
    }
    
    private var rightColumnPrice: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimal())
                .bold()
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.green : Color.red)
            
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
    private var rightColumnHistory: some View {
        VStack(alignment: .trailing) {
            Text("\(coin.isPurchased ?? true ? "+" : "-") \(coin.currentHoldingsValue.asCurrencyWith2Decimal())")
                .bold()
                .foregroundColor((coin.isPurchased ?? true) ? Color.green : Color.red)
            
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
    private var rightColumnHolding: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimal())
                .bold()
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
