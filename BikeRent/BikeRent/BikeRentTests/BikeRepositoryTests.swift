import XCTest
@testable import BikeRent
import SwiftData

final class BikeRepositoryTests: XCTestCase {
    
    var repository: BikeRepository!
    
    override func setUp() {
        super.setUp()
        repository = BikeRepository()
    }
    
    override func tearDown() {
        repository = nil
        super.tearDown()
    }

    func testBikeInitialization() {
        // Arrange
        let bikeId = UUID()
        let bikeName = "S-Works Tarmac"
        let bikeManufacturer = "Specialized"
        let bikeType = "Road"
        let pricePerMinute = 1.0
        
        // Act
        let bike = Bike(id: bikeId, name: bikeName, manufacturer: bikeManufacturer, type: bikeType, pricePerMinute: pricePerMinute)
        
        // Assert
        XCTAssertEqual(bike.id, bikeId, "Bike ID should be correctly initialized.")
        XCTAssertEqual(bike.name, bikeName, "Bike name should be correctly initialized.")
        XCTAssertEqual(bike.manufacturer, bikeManufacturer, "Bike manufacturer should be correctly initialized.")
        XCTAssertEqual(bike.type, bikeType, "Bike type should be correctly initialized.")
        XCTAssertEqual(bike.pricePerMinute, pricePerMinute, "Bike price per minute should be correctly initialized.")
        XCTAssertTrue(bike.availability, "Bike availability should be initialized to true by default.")
    }
    
    func testLoadBikesFromRepo() {
        // Arrange
        repository.loadBikesFromRepositoryMock()

        // Assert
        XCTAssertEqual(repository.bikes.count, 3, "There should be 3 bikes loaded.")
        
        let firstBike = repository.bikes[0]
        XCTAssertEqual(firstBike.name, "S-Works Tarmac", "First bike name should be 'S-Works Tarmac'.")
        XCTAssertEqual(firstBike.manufacturer, "Specialized", "First bike manufacturer should be 'Specialized'.")
        XCTAssertEqual(firstBike.type, "Road", "First bike type should be 'Road'.")
        XCTAssertEqual(firstBike.pricePerMinute, 1.0, "First bike price per minute should be 1.0.")
    }
    
    func testRepositoryInitialization() {
        // Arrange
        let bikes = repository.bikes
        
        // Assert
        XCTAssertEqual(bikes.count, 3, "There should be 3 bikes in the repository after initialization.")
    }
}
