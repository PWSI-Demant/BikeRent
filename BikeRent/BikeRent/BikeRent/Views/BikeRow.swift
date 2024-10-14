import Swift
import SwiftUI

struct BikeRow: View {
    let bike: Bike
    @Binding var selectedBike: Bike?
    let isRenting: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(bike.name)
                    .font(.headline)
                Text(bike.manufacturer)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(bike.type)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(bike.pricePerMinute, specifier: "%.2f") $/min")
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
        .background(selectedBike == bike ? Color.blue.opacity(0.2) : Color.clear)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onTapGesture {
            onTap()
        }
    }
}
