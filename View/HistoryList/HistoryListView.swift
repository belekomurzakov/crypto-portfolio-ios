import SwiftUI

struct HistoryListView: View {
    var historyViewModel: HistoryListViewModel

    var body: some View {
        NavigationView {
            activityHistoryList
                .listStyle(PlainListStyle())
                .navigationTitle("History")
        }
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView(historyViewModel: HistoryListViewModel())
    }
}

extension HistoryListView {
    private var activityHistoryList: some View {
        List {
            ForEach(historyViewModel.activityHistory, id: \.self) { crypto in
                RowCryptoView(showColumnHolding: false, showColumnHistory: true, coin: crypto)
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
