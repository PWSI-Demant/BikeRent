import XCTest
@testable import BikeRent
import SwiftData
import Combine

protocol ContextProtocol {
    func save() throws
}

class ModelContextWrapper: ContextProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save() throws {
        try context.save()
    }
}

final class RentBikeViewModelTests: XCTestCase {
    var viewModel: RentBikeViewModel!
    var mockContext: MockContext!
    var bikeRepo: BikeRepository!

    override func setUp() {
        super.setUp()
        // Use the MockContext instead of MockModelContext
        mockContext = MockContext()
        bikeRepo = BikeRepository()  // Initialize your bike repository
        viewModel = RentBikeViewModel(context: mockContext, bikeRepo: bikeRepo)
    }

    override func tearDown() {
        viewModel = nil
        mockContext = nil
        bikeRepo = nil
        super.tearDown()
    }

    // Example test method
    func testStartRental() {
        // Arrange
        let bike = Bike(id: UUID(), name: "Test Bike", manufacturer: "Test Manufacturer", type: "Test Type", pricePerMinute: 1.0)
        
        // Act
        viewModel.startRental(for: bike)

        // Assert
        XCTAssertTrue(viewModel.isRenting, "Should be renting after starting rental.")
        XCTAssertEqual(viewModel.rentedBike?.name, bike.name, "Rented bike should match the selected bike.")
        XCTAssertFalse(bike.availability, "Bike availability should be set to false after renting.")
    }

    func testStopRental() {
        // Arrange
        let bike = Bike(id: UUID(), name: "Test Bike", manufacturer: "Test Manufacturer", type: "Test Type", pricePerMinute: 1.0)
        viewModel.startRental(for: bike)

        // Act
        viewModel.stopRental()

        // Assert
        XCTAssertFalse(viewModel.isRenting, "Should not be renting after stopping rental.")
        XCTAssertTrue(bike.availability, "Bike availability should be set to true after stopping rental.")
        XCTAssertTrue(mockContext.isSaveCalled, "Save should be called when stopping rental.")
    }

    func testStartRentalFailsOnSave() {
        // Arrange
        mockContext.shouldFailSave = true
        let bike = Bike(id: UUID(), name: "Test Bike", manufacturer: "Test Manufacturer", type: "Test Type", pricePerMinute: 1.0)

        // Act
        viewModel.startRental(for: bike)

        // Assert
        XCTAssertFalse(viewModel.isRenting, "Should not be renting if save fails.")
        XCTAssertEqual(viewModel.rentedBike, nil, "Rented bike should be nil if rental fails.")
        XCTAssertTrue(mockContext.isSaveCalled, "Save should be called even if it fails.")
    }
}
