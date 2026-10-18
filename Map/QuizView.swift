import SwiftUI

struct QuizView: View {
    let continent: String
    private let questions: [QuizQuestion]

    @State private var currentIndex = 0
    @State private var lives = 3
    @State private var quizScore = 0
    @State private var selectedAnswer: String?
    @State private var answerOrder: [String]
    @State private var isFinished = false
    @State private var correctFeedbackTrigger = 0
    @State private var incorrectFeedbackTrigger = 0
    @State private var animationTrigger = 0
    @AppStorage("totalQuizScore") private var totalScore = 0

    init(continent: String) {
        let questions = QuizQuestionBank.questions(for: continent)

        self.continent = continent
        self.questions = questions
        _answerOrder = State(initialValue: questions.first?.answers.shuffled() ?? [])
    }

    var body: some View {
        Group {
            if questions.isEmpty {
                emptyView
            } else if isFinished || lives == 0 {
                QuizResultView(
                    ranOutOfLives: lives == 0,
                    quizScore: quizScore,
                    questionCount: questions.count,
                    totalScore: totalScore,
                    restart: restart
                )
            } else {
                quizView
            }
        }
        .navigationTitle("\(continentDisplayName) Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemGroupedBackground))
        .sensoryFeedback(.success, trigger: correctFeedbackTrigger)
        .sensoryFeedback(.error, trigger: incorrectFeedbackTrigger)
    }

    private var quizView: some View {
        let question = questions[currentIndex]

        return ScrollView {
            VStack(spacing: 20) {
                QuizStatusView(
                    lives: lives,
                    totalScore: totalScore,
                    questionNumber: currentIndex + 1,
                    questionCount: questions.count
                )

                QuizQuestionCard(
                    question: question,
                    answers: answerOrder,
                    selectedAnswer: selectedAnswer,
                    chooseAnswer: choose
                )

                if let selectedAnswer {
                    QuizFeedbackView(
                        isCorrect: selectedAnswer == question.correctAnswer,
                        correctAnswer: question.correctAnswer,
                        animationTrigger: animationTrigger
                    )

                    Button(nextButtonTitle, action: advance)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                }
            }
            .padding()
        }
    }

    private var emptyView: some View {
        ContentUnavailableView(
            "No Quiz Available",
            systemImage: "questionmark.circle",
            description: Text("Questions for \(continentDisplayName) have not been added yet.")
        )
    }

    private var nextButtonTitle: String {
        currentIndex + 1 == questions.count ? "See Results" : "Next Question"
    }

    private var continentDisplayName: String {
        switch continent {
        case "NorthAmerica": "North America"
        case "SouthAmerica": "South America"
        default: continent
        }
    }

    private func choose(_ answer: String) {
        guard selectedAnswer == nil else { return }

        let isCorrect = answer == questions[currentIndex].correctAnswer

        withAnimation(.spring(duration: 0.3, bounce: 0.25)) {
            selectedAnswer = answer
            animationTrigger += 1

            if isCorrect {
                quizScore += 1
                totalScore += 1
                correctFeedbackTrigger += 1
            } else {
                lives -= 1
                incorrectFeedbackTrigger += 1
            }
        }
    }

    private func advance() {
        guard selectedAnswer != nil else { return }

        if currentIndex + 1 < questions.count, lives > 0 {
            currentIndex += 1
            selectedAnswer = nil
            answerOrder = questions[currentIndex].answers.shuffled()
        } else {
            isFinished = true
        }
    }

    private func restart() {
        currentIndex = 0
        lives = 3
        quizScore = 0
        selectedAnswer = nil
        answerOrder = questions.first?.answers.shuffled() ?? []
        isFinished = false
    }
}

#Preview {
    NavigationStack {
        QuizView(continent: "Asia")
    }
}
