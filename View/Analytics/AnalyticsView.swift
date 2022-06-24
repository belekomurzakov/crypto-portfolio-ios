import SwiftUI
import SwiftUICharts

struct AnalyticsView: View {
    var historyViewModel: HistoryListViewModel
    @EnvironmentObject private var priceListViewModel: PriceListViewModel
    
    var body: some View {
        NavigationView {
            VStack() {
                LineChartView(data: historyViewModel.activityHistoryLine, title: "Progression", form:ChartForm.extraLarge, dropShadow: true)
                    .padding(.vertical, 30)
                BarChartView(data: ChartData(values: priceListViewModel.charDataList), title: "Particularly", form:ChartForm.extraLarge, dropShadow: true)
                Spacer()
            }.navigationTitle("Analytics")
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(historyViewModel: HistoryListViewModel()).environmentObject(dev.priceListViewModel)
    }
}
