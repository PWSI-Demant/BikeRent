import SwiftUI
import SwiftData

struct RentalHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var rentalHistory: [RentalHistory]
    
    var body: some View {
        VStack {
            Text("Rental History")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(rentalHistory.sorted(by: { $0.rentalDate > $1.rentalDate })) { history in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(history.bikeName) by \(history.bikeManufacturer)")
                            .font(.headline)
                        Text("Type: \(history.bikeType)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Total Cost: \(history.totalCost, specifier: "%.2f")$")
                            .font(.body)
                        Text("Date: \(formattedDate(history.rentalDate))")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .onDelete(perform: deleteHistoryItem)
            }

            Button("Clear All History") {
                clearAllHistory()
            }
            .foregroundColor(.red)
            .padding()
        }
        .navigationTitle("History")
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func deleteHistoryItem(at offsets: IndexSet) {
        for index in offsets {
            let historyItem = rentalHistory[index]
            modelContext.delete(historyItem)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to save after deleting history item: \(error.localizedDescription)")
        }
    }

    private func clearAllHistory() {
        for history in rentalHistory {
            modelContext.delete(history)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to save after clearing history: \(error.localizedDescription)")
        }
    }
}
