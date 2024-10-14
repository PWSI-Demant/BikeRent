import SwiftUI
import SwiftData
import Combine

class RentBikeViewModel: ObservableObject {
    @Published var selectedBike: Bike? = nil
    @Published var isRenting: Bool = false
    @Published var rentalPrice: Double = 0.0
    @Published var rentedBike: Bike? = nil
    @Published var showSummaryView: Bool = false
    @Published var rentalTimer: Timer?

    internal var modelContext: ModelContext
    internal var bikeRepo: BikeRepository

    init(modelContext: ModelContext, bikeRepo: BikeRepository) {
        self.modelContext = modelContext
        self.bikeRepo = bikeRepo
    }

    func startRental(for bike: Bike) {
        rentedBike = bike
        rentalPrice = 0.0
        isRenting = true
        selectedBike = nil
        bike.availability = false
        saveContext()
        rentalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateRentalCost()
        }
    }

    func updateRentalCost() {
        if let bike = rentedBike {
            let bikePricePerMinute = Double(bike.pricePerMinute)
            let costForOneSecond = (bikePricePerMinute / 60.0)
            rentalPrice = (rentalPrice + costForOneSecond).rounded(toPlaces: 2)
        }
    }

    func stopRental() {
        rentalTimer?.invalidate()
        showSummaryView = true
        isRenting = false
        rentedBike?.availability = true
        saveContext()
    }

    func resetRental() {
        rentedBike = nil
        rentalPrice = 0.0
        isRenting = false
        showSummaryView = false
    }

    func resetSelection() {
        selectedBike = nil
    }

    func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
