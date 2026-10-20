import SwiftUI

struct QuizQuestionCard: View {
    let question: QuizQuestion
    let answers: [String]
    let selectedAnswer: String?
    let chooseAnswer: (String) -> Void

    var body: some View {
        VStack(spacing: 14) {
            Label(question.location, systemImage: "mappin.and.ellipse")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            questionImage
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 12)
                .accessibilityLabel("Photo from \(question.location)")

            Text(question.prompt)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 10) {
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
        .padding(.vertical, 6)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var questionImage: Image {
        if let dataAsset = NSDataAsset(name: question.imageName),
           let image = UIImage(data: dataAsset.data) {
            return Image(uiImage: image)
        }

        return Image(question.imageName)
    }
}

private struct QuizAnswerButton: View {
    let answer: String
    let correctAnswer: String
    let selectedAnswer: String?
    let action: () -> Void

    private var isCorrect: Bool {
        answer == correctAnswer
    }

    private var isSelected: Bool {
        answer == selectedAnswer
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(answer)
                    .multilineTextAlignment(.leading)

                Spacer()

                answerIndicator
            }
            .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(.bordered)
        .tint(tint)
        .disabled(selectedAnswer != nil)
        .accessibilityLabel(answer)
        .accessibilityValue(accessibilityValue)
    }

    @ViewBuilder
    private var answerIndicator: some View {
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

    private var tint: Color {
        guard selectedAnswer != nil else {
            return .accentColor
        }

        if isCorrect {
            return .green
        }

        if isSelected {
            return .red
        }

        return .secondary
    }

    private var accessibilityValue: String {
        guard selectedAnswer != nil else {
            return ""
        }

        if isCorrect {
            return "Correct answer"
        }

        if isSelected {
            return "Selected, incorrect"
        }

        return "Not selected"
    }
}
