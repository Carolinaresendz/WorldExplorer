import SwiftUI

struct FactsView: View {
    let continent: String

    var body: some View {
        ContentUnavailableView(
            "No Facts Yet",
            systemImage: "book.closed",
            description: Text("Facts for \(continentDisplayName) will appear here.")
        )
        .navigationTitle("\(continentDisplayName) Facts")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var continentDisplayName: String {
        switch continent {
        case "NorthAmerica":
            return "North America"
        case "SouthAmerica":
            return "South America"
        default:
            return continent
        }
    }
}

#Preview {
    NavigationStack {
        FactsView(continent: "Asia")
    }
}
