import SwiftUI

struct MainMenuView: View {
    @State private var animate = false
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var bikeRepo = BikeRepository()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Bike Rental App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .scaleEffect(animate ? 8.2 : 1.0)
                    .animation(.easeInOut(duration: 8.5).repeatForever(autoreverses: true), value: animate)
                    .onAppear {
                        animate.toggle()
                    }

                Spacer().frame(height: 50)
                
                NavigationLink(destination: RentBikeView(modelContext: modelContext, bikeRepo: bikeRepo)) {
                    Text("Rent a Bike")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
