enum CultureFactData {
    static let facts: [CultureFact] = africa + asia + europe + northAmerica + southAmerica + oceania

    static func facts(for region: WorldRegion) -> [CultureFact] {
        switch region.factsCategory {
        case .africa:
            africa
        case .asia:
            asia
        case .europe:
            europe
        case .northAmerica:
            northAmerica
        case .southAmerica:
            southAmerica
        case .oceania:
            oceania
        }
    }
}
