import SwiftUI

struct QuizStatusView: View {
    let lives: Int
    let totalScore: Int
    let questionNumber: Int
    let questionCount: Int

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label("\(lives) lives", systemImage: "heart.fill")
                    .foregroundStyle(.red)

                Spacer()

                Label("\(totalScore) total points", systemImage: "star.fill")
                    .foregroundStyle(.secondary)
            }
            .font(.headline)

            ProgressView(
                value: Double(questionNumber),
                total: Double(questionCount)
            )
            .accessibilityLabel("Quiz progress")
            .accessibilityValue(
                "Question \(questionNumber) of \(questionCount)"
            )

            Text("Question \(questionNumber) of \(questionCount)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
