import CloudKit
import SwiftUI

class BikeRepository: ObservableObject {
    @Published var bikes: [Bike] = []

    init() {
        loadBikesFromRepositoryMock()
    }

    func loadBikesFromRepositoryMock() {
        self.bikes = [
            Bike(id: UUID(), name: "S-Works Tarmac", manufacturer: "Specialized", type: "Road", pricePerMinute: 1),
            Bike(id: UUID(), name: "Venge Custom", manufacturer: "Specialized", type: "Road", pricePerMinute: 0.45),
            Bike(id: UUID(), name: "ProCaliber", manufacturer: "Trek", type: "MTB", pricePerMinute: 0.65)
        ]
    }
}
