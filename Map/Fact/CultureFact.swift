import Foundation

enum FactCategory: String {
    case asia = "Asia"
    case europe = "Europe"
    case africa = "Africa"
    case americas = "Americas"
    case oceania = "Oceania"
}

struct CultureFact: Identifiable {
    let id: String
    let category: FactCategory
    let country: String
    let flag: String
    let title: String
    let catchyHook: String
    let fullFact: String
    let imageName: String
}
