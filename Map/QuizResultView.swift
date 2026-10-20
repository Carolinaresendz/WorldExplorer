import SwiftUI

struct QuizResultView: View {
    let ranOutOfLives: Bool
    let quizScore: Int
    let questionCount: Int
    let totalScore: Int
    let restart: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(
                ranOutOfLives ? "Out of Lives" : "Quiz Complete",
                systemImage: ranOutOfLives
                    ? "heart.slash"
                    : "checkmark.seal.fill"
            )
        } description: {
            Text(
                "You scored \(quizScore) out of \(questionCount). "
                    + "Your total score is \(totalScore)."
            )
        } actions: {
            Button("Play Again", action: restart)
                .buttonStyle(.borderedProminent)
        }
    }
}
