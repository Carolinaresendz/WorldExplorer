enum QuizQuestionBank {
    static func questions(for region: WorldRegion) -> [QuizQuestion] {
        switch region {
        case .africa:
            africa
        case .asia:
            asia
        case .europe:
            europe
        case .northAmerica:
            northAmerica
        case .oceania:
            oceania
        case .southAmerica:
            southAmerica
        }
    }
}
