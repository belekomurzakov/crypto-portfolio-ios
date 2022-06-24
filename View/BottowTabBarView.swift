import SwiftUI

struct BottowTabBarView: View {
    var body: some View {
        TabView{
            //PriceListView(PriceListViewModel: PriceListViewModel())
            Text("History")
            .tabItem{
                    Image(systemName: "clock")
                    Text("History")
                }
        }
    }}

struct BottowTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottowTabBarView()
    }
}
