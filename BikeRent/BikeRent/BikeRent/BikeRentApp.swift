import SwiftUI
import SwiftData

@main
struct BikeRentApp: App {
    let modelContainer: ModelContainer

    init() {
        modelContainer = try! ModelContainer(for: Bike.self, RentalHistory.self)
    }
    
    var body: some Scene {
        WindowGroup {
            RentBikeView(modelContext: modelContainer.mainContext, bikeRepo: BikeRepository())
                .modelContainer(modelContainer)
        }
    }
}
