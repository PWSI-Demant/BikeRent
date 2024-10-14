import SwiftUI

struct BikeSelectionView: View {
    @ObservedObject var viewModel: RentBikeViewModel
    let selectedBike: Bike

    var body: some View {
        VStack(alignment: .leading) {
            Text("Selected Bike: \(selectedBike.name)")
                .font(.headline)
                .padding(.horizontal)

            HStack {
                Button(action: {
                    viewModel.startRental(for: selectedBike)
                }) {
                    Text("Rent Bike")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                Button(action: {
                    viewModel.resetSelection()
                }) {
                    Text("Cancel")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
}
