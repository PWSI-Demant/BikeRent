import XCTest
import SwiftData
import SwiftUI
@testable import BikeRent

final class BikeViewModelTests: XCTestCase {
    
    var viewModel: BikeViewModel!
    var modelContainer: ModelContainer!
    
    override func setUp() async throws {
        try await super.setUp()

        modelContainer = try! ModelContainer(for: Bike.self, RentalHistory.self)

        viewModel = await BikeViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        modelContainer = nil
        super.tearDown()
    }

    @MainActor
    func testRentBike() async {
        // Arrange
        let bike = Bike(name: "Mountain Bike", manufacturer: "BikeCo", type: "Mountain", pricePerMinute: 1.5)

        let context = modelContainer.mainContext
        
        do {
            let fetchDescriptor = FetchDescriptor<Bike>()
            let existingBikes = try context.fetch(fetchDescriptor)
            for bike in existingBikes {
                context.delete(bike)
            }
            try context.save()
        } catch {
            XCTFail("Failed to clean up bikes: \(error)")
        }

        // Act
        viewModel.rentBike(bike, context: context)

        // Assert
        XCTAssertEqual(viewModel.rentedBikes.count, 1, "Should have one rented bike")
        XCTAssertEqual(viewModel.rentedBikes.first?.name, "Mountain Bike", "The rented bike's name should match")
        
        let savedBikes = await Task { @MainActor () -> [Bike] in
            let context = modelContainer.mainContext
            
            let fetchDescriptor = FetchDescriptor<Bike>()
            do {
                return try context.fetch(fetchDescriptor)
            } catch {
                XCTFail("Failed to fetch bikes: \(error)")
                return []
            }
        }.value
        
        XCTAssertEqual(savedBikes.count, 1, "There should be one bike saved in the context")
        XCTAssertEqual(savedBikes.first?.name, "Mountain Bike", "The inserted bike's name should match")
    }
    
    @MainActor
    func testRentMultipleBikes() async {
        // Arrange
        let bike1 = Bike(name: "Road Bike", manufacturer: "SpeedyBikes", type: "Road", pricePerMinute: 2.0)
        let bike2 = Bike(name: "City Bike", manufacturer: "UrbanBikes", type: "City", pricePerMinute: 1.0)

        let context = modelContainer.mainContext
        
        do {
            let fetchDescriptor = FetchDescriptor<Bike>()
            let existingBikes = try context.fetch(fetchDescriptor)
            for bike in existingBikes {
                context.delete(bike)
            }
            try context.save()
        } catch {
            XCTFail("Failed to clean up bikes: \(error)")
        }

        // Act
        viewModel.rentBike(bike1, context: context)
        viewModel.rentBike(bike2, context: context)

        // Assert
        XCTAssertEqual(viewModel.rentedBikes.count, 2, "Should have two rented bikes")
        
        let savedBikes = await Task { @MainActor () -> [Bike] in
            let context = modelContainer.mainContext
            
            let fetchDescriptor = FetchDescriptor<Bike>()
            do {
                return try context.fetch(fetchDescriptor)
            } catch {
                XCTFail("Failed to fetch bikes: \(error)")
                return []
            }
        }.value
        
        XCTAssertEqual(savedBikes.count, 2, "There should be two bikes saved in the context")
    }

    @MainActor
    func testRentBikeFailure() async {
        // Arrange
        let bike = Bike(name: "Mountain Bike", manufacturer: "BikeCo", type: "Mountain", pricePerMinute: 1.5)
        
        let context = modelContainer.mainContext
        
        do {
            let fetchDescriptor = FetchDescriptor<Bike>()
            let existingBikes = try context.fetch(fetchDescriptor)
            for bike in existingBikes {
                context.delete(bike)
            }
            try context.save()
        } catch {
            XCTFail("Failed to clean up bikes: \(error)")
        }

        // Act
        viewModel.rentBike(bike, context: context)
        
        viewModel.rentBike(bike, context: context)
        
        // Assert
        XCTAssertEqual(viewModel.rentedBikes.count, 1, "Should still have only one rented bike if duplicates are not allowed")
    }
}
