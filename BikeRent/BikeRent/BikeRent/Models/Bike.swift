import Foundation
import SwiftData

@Model
class Bike: Identifiable {
    @Attribute var id: UUID
    @Attribute var name: String
    @Attribute var manufacturer: String
    @Attribute var type: String 
    @Attribute var pricePerMinute: Double
    @Attribute var availability: Bool = true

    init(id: UUID = UUID(), name: String, manufacturer: String, type: String, pricePerMinute: Double) {
        self.id = id    
        self.name = name
        self.manufacturer = manufacturer
        self.type = type
        self.pricePerMinute = pricePerMinute
        self.availability = true
    }
}
