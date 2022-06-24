import SwiftUI
import CoreData

struct ContentView: View {
    @State private var selection = 0
    @EnvironmentObject private var viewModel: PriceListViewModel
    
    var body: some View {
        TabView(selection: $selection) {
            AnalyticsView(historyViewModel:HistoryListViewModel())
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Analytics")
                }
                .tag(2)
            PriceListView()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Prices")
                }
                .tag(0)
            PortfolioListView()
                .tabItem {
                    Image(systemName: "case")
                    Text("Portfolio")
                }
                .tag(1)
            HistoryListView(historyViewModel:HistoryListViewModel())
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
                .tag(3)
        }.environmentObject(viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
