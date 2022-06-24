import Foundation
import CoreData

class PortfolioService {
    
    private let entityName: String = "Portfolio"
    @Published var savedEntities: [Portfolio] = []
    
    init() {
        PersistenceController.shared.container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getPortfolio()
        }
    }
    
    // MARK: PUBLIC
    
    func updatePortfolio(crypto: Coin, amount: Double, isPurchased: Bool) {
        if let entity = savedEntities.first(where: { $0.cryptoId == crypto.id } ) {
            if amount > 0 {
                update(entity: entity, amount: amount, isPurchased: isPurchased)
            } else {
                //remove(entity: entity)
            }
        } else {
            add(crypto: crypto, amount: amount, isPurchased: isPurchased)
        }
    }
    
    // MARK: PRIVATE
    private func getPortfolio() {
        let request = NSFetchRequest<Portfolio>(entityName: entityName)
        do {
            savedEntities = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    private func add(crypto: Coin, amount: Double, isPurchased: Bool) {
        let entity = Portfolio(context: PersistenceController.shared.container.viewContext)
        entity.cryptoId = crypto.id
        entity.amount = amount
        
        addActivityHistory(cryptoId: crypto.id, amount: amount, isPurchased: isPurchased)
        applyChanges()
    }
    
    private func update(entity: Portfolio, amount: Double, isPurchased: Bool) {
        if (isPurchased) {
            entity.amount += amount
        } else {
            entity.amount -= amount
        }
        addActivityHistory(cryptoId: entity.cryptoId ?? "", amount: amount, isPurchased: isPurchased)
        applyChanges()
    }
    
    private func remove(entity: Portfolio) {
        PersistenceController.shared.container.viewContext.delete(entity)
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
        getPortfolio()
    }
    
    private func addActivityHistory(cryptoId: String, amount: Double, isPurchased: Bool) {
        let activityHistory = ActivityHistory(context: PersistenceController.shared.container.viewContext)
        
        activityHistory.cryptoId = cryptoId
        activityHistory.amount = amount
        activityHistory.isPurchased = isPurchased

        applyChanges()
    }
}

