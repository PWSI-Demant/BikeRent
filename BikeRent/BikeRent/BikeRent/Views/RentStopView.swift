import SwiftUI

struct RentStopView: View {
    @ObservedObject var viewModel: RentBikeViewModel

    var body: some View {
        VStack {
            Button(action: {
                viewModel.stopRental()
            }) {
                Text("Stop Rental")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            .padding(.bottom)

            Text("Total Rental Cost: \(viewModel.rentalPrice, specifier: "%.2f")$")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
        }
    }
}
