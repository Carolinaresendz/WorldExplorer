struct QuizQuestion: Identifiable {
    let id: String
    let location: String
    let prompt: String
    let answers: [String]
    let correctAnswer: String
    let systemImage: String
}
