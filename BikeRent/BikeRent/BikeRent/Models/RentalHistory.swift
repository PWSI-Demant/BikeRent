import Foundation
import SwiftData

@Model
class RentalHistory{
    @Attribute() var bikeName: String
    @Attribute() var bikeManufacturer: String
    @Attribute() var bikeType: String
    @Attribute() var totalCost: Double
    @Attribute() var rentalDate: Date

    init(bikeName: String, bikeManufacturer: String, bikeType: String, totalCost: Double, rentalDate: Date) {
        self.bikeName = bikeName
        self.bikeManufacturer = bikeManufacturer
        self.bikeType = bikeType
        self.totalCost = totalCost
        self.rentalDate = rentalDate
    }
}
