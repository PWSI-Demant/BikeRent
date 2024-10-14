import XCTest
import SwiftUI
import ViewInspector
import SwiftData
@testable import BikeRent

final class MainMenuViewTests: XCTestCase {
    
    private var modelContainer: ModelContainer!
    
    override func setUp() {
        super.setUp()
        
        modelContainer = try? ModelContainer(for: Bike.self, RentalHistory.self)
    }
    
    override func tearDown() {
        modelContainer = nil
        super.tearDown()
    }
    
    @MainActor
    func testMainMenuViewTitle() throws {
        // Arrange
        let view = MainMenuView()
            .environment(\.modelContext, modelContainer.mainContext)
        
        // Act
        let title = try view.inspect().find(text: "Bike Rental App").string()
        
        // Assert
        XCTAssertEqual(title, "Bike Rental App", "The title should be 'Bike Rental App'")
    }
    
    @MainActor
    func testNavigationToRentBikeView() throws {
        // Arrange
        let view = MainMenuView()
            .environment(\.modelContext, modelContainer.mainContext)
        
        // Act
        let navLink = try view.inspect().find(ViewType.NavigationLink.self)
        let destination = try navLink.view(RentBikeView.self)

        // Assert
        XCTAssertNotNil(destination, "NavigationLink should lead to RentBikeView")
    }
    
    @MainActor
    func testAnimationOnAppear() throws {
        // Arrange
        let view = MainMenuView()
            .environment(\.modelContext, modelContainer.mainContext)
        
        // Act
        let animationScale = try view.inspect().find(text: "Bike Rental App").scaleEffect()
        
        // Assert
        XCTAssertEqual(animationScale, CGSize(width: 1.0, height: 1.0), "The title should start with a scale of (1.0, 1.0)")
    }
}
