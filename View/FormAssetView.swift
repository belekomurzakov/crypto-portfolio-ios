import SwiftUI

struct FormAssetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let coin: Coin
    let isPurchase: Bool
    let removePadding: CGFloat = 100
    let addPadding: CGFloat = 50
    @State var cryptoAmount: String = ""
    @State private var showingAlert = false
    @EnvironmentObject var viewModel: PriceListViewModel
    
    var body: some View {
        VStack {
            ZStack{
                backgroundRectangle
                VStack {
                    logoWithPriceView
                    addAssetTextInputView
                }
            }
            buttonView
        }
        .navigationBarTitle("\(isPurchase ? "Add crypto" : "Remove crypto")")
        .frame(height: 600, alignment: .top)
    }
}

struct AddAssetView_Previews: PreviewProvider {
    static var previews: some View {
        FormAssetView(coin: dev.coin, isPurchase: false)
            .environmentObject(PriceListViewModel())
    }
}

extension FormAssetView {
    private var addAssetTextInputView: some View {
        VStack {
            Text(getCurrentValue().asCurrencyWith6Decimal())
                .multilineTextAlignment(TextAlignment.leading)
                .frame(width: 300, alignment: .trailing)
                .keyboardType(.decimalPad)
                .disabled(true)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(Color.gray,lineWidth: 0.8)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                        .frame(width: 320, height: 50))
                .padding()
            TextField(coin.symbol.uppercased(), text: $cryptoAmount)
                .multilineTextAlignment(TextAlignment.trailing)
                .frame(width: 300)
                .keyboardType(.decimalPad)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(Color.gray,lineWidth: 0.8)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                        .frame(width: 320, height: 50))
                .padding()
        }
    }
    
    private var logoWithPriceView: some View {
        HStack {
            CoinImageView(crypto: coin)
                .frame(width: 60, height: 60, alignment: .leading)
                .padding(.trailing, 40)
            
            Text(isPurchase ? "1 \(coin.symbol.uppercased()) = \(coin.currentPrice.asCurrencyWith6Decimal())" : viewModel.getCurrentHolding(cryptoId: coin.id).asCurrencyWith6Decimal())
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.leading, isPurchase ? addPadding : removePadding)
            
        }.frame(height: 200, alignment: .top)
    }
    
    private var backgroundRectangle: some View {
        RoundedRectangle(cornerRadius: 25)
            .strokeBorder(Color.gray,lineWidth: 1)
            .frame(width: 350, height: 400, alignment: .top)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 350, height: 400, alignment: .top)
                    .foregroundColor(Color.white))
    }
    
    private func getCurrentValue() -> Double {
        if let cryptoQuantity = Double(cryptoAmount) {
            return cryptoQuantity * (coin.currentPrice)
        }
        return 0
    }
    
    private var buttonView: some View {
        Button("\(isPurchase ? "Add assets" : "Remove assets")") {
            saveButton(cryptoId: coin.id)
            if (!showingAlert) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .tint(isPurchase ? .blue : .red)
        .buttonStyle(.borderedProminent)
        .keyboardShortcut(.defaultAction)
        .padding(10)
        .alert("You don't have such an assets", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func saveButton(cryptoId: String) {
        guard let amount = Double(cryptoAmount) else { return }
        if amount > self.coin.currentHoldings ?? 0 && !isPurchase { return showingAlert = true }
        viewModel.updatePortfolio(crypto: coin, amount: amount, isPurchased: isPurchase)
    }
}
