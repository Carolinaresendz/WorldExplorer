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

            ProgressView(value: Double(questionNumber), total: Double(questionCount))
                .accessibilityLabel("Quiz progress")
                .accessibilityValue("Question \(questionNumber) of \(questionCount)")

            Text("Question \(questionNumber) of \(questionCount)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct QuizQuestionCard: View {
    let question: QuizQuestion
    let answers: [String]
    let selectedAnswer: String?
    let chooseAnswer: (String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Label(question.location, systemImage: "mappin.and.ellipse")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Image(systemName: question.systemImage)
                .font(.system(.largeTitle, design: .rounded, weight: .medium))
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            Text(question.prompt)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 12) {
                ForEach(answers, id: \.self) { answer in
                    QuizAnswerButton(
                        answer: answer,
                        correctAnswer: question.correctAnswer,
                        selectedAnswer: selectedAnswer
                    ) {
                        chooseAnswer(answer)
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct QuizAnswerButton: View {
    let answer: String
    let correctAnswer: String
    let selectedAnswer: String?
    let action: () -> Void

    private var isCorrect: Bool { answer == correctAnswer }
    private var isSelected: Bool { answer == selectedAnswer }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(answer)
                    .multilineTextAlignment(.leading)

                Spacer()

                if selectedAnswer != nil, isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .accessibilityHidden(true)
                } else if isSelected {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                        .accessibilityHidden(true)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(.bordered)
        .tint(tint)
        .disabled(selectedAnswer != nil)
        .accessibilityLabel(answer)
        .accessibilityValue(accessibilityValue)
    }

    private var tint: Color {
        guard selectedAnswer != nil else { return .accentColor }
        if isCorrect { return .green }
        if isSelected { return .red }
        return .secondary
    }

    private var accessibilityValue: String {
        guard selectedAnswer != nil else { return "" }
        if isCorrect { return "Correct answer" }
        if isSelected { return "Selected, incorrect" }
        return "Not selected"
    }
}

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
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .accessibilityHidden(true)
        }
        .foregroundStyle(isCorrect ? .green : .red)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .transition(.scale(scale: 0.96).combined(with: .opacity))
        .symbolEffect(.bounce, value: animationTrigger)
        .accessibilityElement(children: .combine)
    }
}

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
                systemImage: ranOutOfLives ? "heart.slash" : "checkmark.seal.fill"
            )
        } description: {
            Text("You scored \(quizScore) out of \(questionCount). Your total score is \(totalScore).")
        } actions: {
            Button("Play Again", action: restart)
                .buttonStyle(.borderedProminent)
        }
    }
}
