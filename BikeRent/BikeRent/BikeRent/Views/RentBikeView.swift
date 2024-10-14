import SwiftUI
import SwiftData

struct RentBikeView: View {
    @StateObject private var viewModel: RentBikeViewModel

    init(modelContext: ModelContext, bikeRepo: BikeRepository) {
        _viewModel = StateObject(wrappedValue: RentBikeViewModel(modelContext: modelContext, bikeRepo: bikeRepo))
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Available Bikes")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                if let rentedBike = viewModel.rentedBike {
                    Text("Currently Renting: \(rentedBike.name) by \(rentedBike.manufacturer)")
                        .foregroundColor(.green)
                        .font(.headline)
                        .padding(.horizontal)
                }

                List(viewModel.bikeRepo.bikes.filter { $0.availability }) { bike in
                    BikeRow(
                        bike: bike,
                        selectedBike: $viewModel.selectedBike,
                        isRenting: viewModel.isRenting,
                        onTap: {
                            if !viewModel.isRenting {
                                viewModel.selectedBike = bike
                            }
                        }
                    )
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal)

                Spacer()

                if let selectedBike = viewModel.selectedBike {
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
                } else if !viewModel.isRenting {
                    Text("Please select a bike to rent")
                        .padding()
                        .foregroundColor(.black)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                if viewModel.isRenting {
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

                NavigationLink(destination: RentalHistoryView()) {
                    Text("View Rental History")
                        .padding()
                        .font(.title3)
                        .fontWeight(.black)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.brown)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Rent a Bike")
            .onDisappear {
                viewModel.rentalTimer?.invalidate()
            }
            .navigationDestination(isPresented: $viewModel.showSummaryView) {
                if let rentedBike = viewModel.rentedBike {
                    SummaryView(bike: rentedBike, totalCost: viewModel.rentalPrice, onConfirm: {
                        viewModel.resetRental()
                    })
                }
            }
        }
    }
}
