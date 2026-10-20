enum CultureFactData {
    static let facts: [CultureFact] = africa + asia + europe + americas + oceania

    static func facts(for region: WorldRegion) -> [CultureFact] {
        switch region.factsCategory {
        case .africa:
            africa
        case .asia:
            asia
        case .europe:
            europe
        case .americas:
            americas
        case .oceania:
            oceania
        }
    }
}
