import Foundation
import CoreData

class ActivityHistoryService {
    
    private let entityActivityHistory: String = "ActivityHistory"
    @Published var savedActivityHistory: [ActivityHistory] = []
    
    init() {
        PersistenceController.shared.container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getActivityHistory()
        }
    }
    
    // MARK: PUBLIC
    
    func addHistory(crypto: Coin, amount: Double, isPurchased: Bool) {
        add(crypto: crypto, amount: amount, isPurchased: isPurchased)
    }
    
    // MARK: PRIVATE
    private func getActivityHistory() {
        let request = NSFetchRequest<ActivityHistory>(entityName: entityActivityHistory)
        do {
            savedActivityHistory = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    private func add(crypto: Coin, amount: Double, isPurchased: Bool) {
        let entity = ActivityHistory(context: PersistenceController.shared.container.viewContext)
        entity.cryptoId = crypto.id
        entity.amount = amount
        entity.isPurchased = isPurchased
        applyChanges()
    }
    
    private func save() {
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getActivityHistory()
    }
}
