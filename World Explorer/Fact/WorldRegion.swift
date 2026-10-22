import Foundation

enum WorldRegion: String, CaseIterable, Identifiable, Sendable {
    case africa = "Africa"
    case asia = "Asia"
    case europe = "Europe"
    case northAmerica = "NorthAmerica"
    case oceania = "Oceania"
    case southAmerica = "SouthAmerica"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .africa:
            "Africa"
        case .asia:
            "Asia"
        case .europe:
            "Europe"
        case .northAmerica:
            "North America"
        case .oceania:
            "Oceania"
        case .southAmerica:
            "South America"
        }
    }

    var factsCategory: FactCategory {
        switch self {
        case .africa:
            .africa
        case .asia:
            .asia
        case .europe:
            .europe
        case .northAmerica:
            .northAmerica
        case .southAmerica:
            .southAmerica
        case .oceania:
            .oceania
        }
    }

    init?(continent: String) {
        if let match = WorldRegion(rawValue: continent) {
            self = match
            return
        }

        switch continent.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "africa":
            self = .africa
        case "asia":
            self = .asia
        case "europe":
            self = .europe
        case "northamerica", "north america":
            self = .northAmerica
        case "oceania":
            self = .oceania
        case "southamerica", "south america":
            self = .southAmerica
        default:
            return nil
        }
    }
}
