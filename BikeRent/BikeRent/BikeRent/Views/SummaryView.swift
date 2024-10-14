import SwiftUI

struct SummaryView: View {
    var bike: Bike?
    var totalCost: Double
    var onConfirm: () -> Void
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            Text("Rental Summary")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Spacer()

            if let bike = bike {
                VStack(spacing: 3) {
                    HStack {
                        Text("Bike: \(bike.name)")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }

                    HStack {
                        Text("Manufacturer: \(bike.manufacturer)")
                            .font(.subheadline)
                    }
                    .padding()

                    HStack {
                        Text("Type: \(bike.type)")
                            .font(.subheadline)
                    }
                    
                    Spacer()

                    HStack {
                        Text("Total Amount to Pay:")
                            .font(.headline)
                        Spacer()
                        Text("\(totalCost, specifier: "%.2f")$")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
            } else {
                Text("No bike selected.")
            }

            Spacer()

            Button(action: {
                let rentalRecord = RentalHistory(bikeName: bike?.name ?? "", bikeManufacturer: bike?.manufacturer ?? "", bikeType: bike?.type ?? "", totalCost: totalCost, rentalDate: Date())
                modelContext.insert(rentalRecord)
                onConfirm()
            }) {
                Text("Confirm Payment")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
    
        private func saveRental() {
            if let bike = bike {
                let rentalDate = Date()
                let rentalHistory = RentalHistory(
                    bikeName: bike.name,
                    bikeManufacturer: bike.manufacturer,
                    bikeType: bike.type,
                    totalCost: totalCost,
                    rentalDate: rentalDate
                )
                modelContext.insert(rentalHistory)
            }
        }
}
