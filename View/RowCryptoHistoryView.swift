import SwiftUI

struct RowCryptoHistoryView: View {
    
    //var crypto : Crypto
    
    var body: some View {
        HStack(spacing: 100) {
            HStack {
                Image("BTC")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .cornerRadius(4)
                    .padding(.vertical, 4)
                Text("Bitcoin")
                    //.font()
                    .bold()
            }
            
            Text("+ 42,10 $")
                //.font()
                .bold()
                .foregroundColor(.green)

        }
        
    }
}

struct RowCryptoHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RowCryptoHistoryView()
    }
}
