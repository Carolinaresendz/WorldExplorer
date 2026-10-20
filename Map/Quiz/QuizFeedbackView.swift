import SwiftUI

struct QuizFeedbackView: View {
    let isCorrect: Bool
    let correctAnswer: String
    let animationTrigger: Int

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(isCorrect ? "Correct" : "Not quite")
                    .font(.headline)

                if !isCorrect {
                    Text("The correct answer is \(correctAnswer).")
                        .font(.subheadline)
                }
            }
        } icon: {
            Image(
                systemName: isCorrect
                    ? "checkmark.circle.fill"
                    : "xmark.circle.fill"
            )
            .accessibilityHidden(true)
        }
        .foregroundStyle(isCorrect ? .green : .red)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .transition(.scale(scale: 0.96).combined(with: .opacity))
        .symbolEffect(.bounce, value: animationTrigger)
        .accessibilityElement(children: .combine)
    }
}
