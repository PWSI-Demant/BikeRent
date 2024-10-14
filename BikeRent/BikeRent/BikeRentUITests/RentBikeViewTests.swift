import XCTest
import SwiftUI
import ViewInspector
import Combine
import SwiftData
@testable import BikeRent

final class RentBikeViewTests: XCTestCase {

    private var modelContainer: ModelContainer!
    private var bikeRepo: BikeRepository!

    override func setUp() {
        super.setUp()

        let schema = Schema([Bike.self, RentalHistory.self])
        modelContainer = try? ModelContainer(for: schema)

        bikeRepo = BikeRepository()
    }

    override func tearDown() {
        modelContainer = nil
        bikeRepo = nil
        super.tearDown()
    }

    @MainActor
        func testTitleIsDisplayed() throws {
            // Arrange
            let view = RentBikeView(modelContext: modelContainer.mainContext, bikeRepo: bikeRepo)

            // Act
            let titleText = try view.inspect().find(text: "Available Bikes").string()
            
            // Assert
            XCTAssertEqual(titleText, "Available Bikes", "The title should display 'Available Bikes'")
        }
        
        @MainActor
        func testBikeListDisplay() throws {
            // Arrange
            let view = RentBikeView(modelContext: modelContainer.mainContext, bikeRepo: bikeRepo)

            // Act
            let bikeRows = try view.inspect().findAll(ViewType.HStack.self)
            
            // Assert
            XCTAssertEqual(bikeRows.count, 3, "There should be 3 bikes displayed in the list")
        }

        @MainActor
        func testSelectBike() throws {
            // Arrange
            let view = RentBikeView(modelContext: modelContainer.mainContext, bikeRepo: bikeRepo)
            
            // Act
            let bikeRow = try view.inspect().find(ViewType.HStack.self, where: { view in
                (try? view.find(text: "S-Works Tarmac")) != nil
            })
            
            try bikeRow.callOnTapGesture()
            
            // Assert
            let selectedBike = try view.inspect().find(ViewType.Text.self, where: { view in
                try view.string().contains("S-Works Tarmac")
            })
            
            XCTAssertNotNil(selectedBike, "A bike should be selected after tapping")
        }
    
//        @MainActor
//        func testRentBikeButton() throws {
//            // Arrange
//            let view = RentBikeView(modelContext: modelContainer.mainContext, bikeRepo: bikeRepo)
//            
//            // Act
//            // Simulate selecting a bike
//            let bikeRow = try view.inspect().find(ViewType.HStack.self, where: { view in
//                (try? view.find(text: "S-Works Tarmac")) != nil
//            })
//            try bikeRow.callOnTapGesture()
//
//            let rentButton = try view.inspect().find(button: "Rent Bike")
//            try rentButton.tap()
//            
//            // Assert
//            let rentingText = try view.inspect().find(text: "Currently Renting: S-Works Tarmac by Specialized")
//            XCTAssertNotNil(rentingText, "After tapping 'Rent Bike', the currently renting bike should be displayed")
//        }
//
//        @MainActor
//        func testStopRentalButton() throws {
//            // Arrange
//            let view = RentBikeView(modelContext: modelContainer.mainContext, bikeRepo: bikeRepo)
//            
//            // Act
//            // Simulate selecting and renting a bike
//            let bikeRow = try view.inspect().find(ViewType.HStack.self, where: { view in
//                (try? view.find(text: "S-Works Tarmac")) != nil
//            })
//            try bikeRow.callOnTapGesture()
//            let rentButton = try view.inspect().find(button: "Rent Bike")
//            try rentButton.tap()
//
//            let stopButton = try view.inspect().find(button: "Stop Rental")
//            try stopButton.tap()
//            
//            // Assert
//            let summaryView = try view.inspect().find(ViewType.Text.self, where: { view in
//                try view.string().contains("Total Rental Cost")
//            })
//            XCTAssertNotNil(summaryView, "After stopping the rental, a summary view should appear")
//        }
    }
