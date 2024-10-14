import SwiftUI
import SwiftData

@MainActor
class BikeViewModel: ObservableObject {
    @Published var rentedBikes: [Bike] = []
    
    func rentBike(_ bike: Bike, context: ModelContext) {
        guard !rentedBikes.contains(where: { $0.id == bike.id }) else {
            print("Bike already rented: \(bike.name)")
            return
        }

        rentedBikes.append(bike)
        context.insert(bike)
        
        do {
            try context.save()
        } catch {
            print("Failed to save rented bike: \(error)")
        }
    }
}
