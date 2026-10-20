import SwiftUI

struct QuizView: View {
    private let region: WorldRegion
    private let questions: [QuizQuestion]

    @State private var currentQuestionIndex = 0
    @State private var lives = 3
    @State private var quizScore = 0
    @State private var selectedAnswer: String?
    @State private var shuffledAnswers: [String]
    @State private var isFinished = false
    @State private var correctFeedbackTrigger = 0
    @State private var incorrectFeedbackTrigger = 0
    @State private var feedbackAnimationTrigger = 0

    @AppStorage("totalQuizScore") private var totalScore = 0

    init(region: WorldRegion) {
        let questions = QuizQuestionBank.questions(for: region)

        self.region = region
        self.questions = questions
        _shuffledAnswers = State(
            initialValue: questions.first?.answers.shuffled() ?? []
        )
    }

    init(continent: String) {
        self.init(region: WorldRegion(continent: continent) ?? .asia)
    }

    var body: some View {
        Group {
            if questions.isEmpty {
                emptyState
            } else if isFinished || lives == 0 {
                results
            } else {
                activeQuiz
            }
        }
        .navigationTitle("\(region.displayName) Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .sensoryFeedback(.success, trigger: correctFeedbackTrigger)
        .sensoryFeedback(.error, trigger: incorrectFeedbackTrigger)
    }

    private var activeQuiz: some View {
        let question = questions[currentQuestionIndex]

        return ScrollView {
            VStack(spacing: 20) {
                QuizStatusView(
                    lives: lives,
                    totalScore: totalScore,
                    questionNumber: currentQuestionIndex + 1,
                    questionCount: questions.count
                )

                QuizQuestionCard(
                    question: question,
                    answers: shuffledAnswers,
                    selectedAnswer: selectedAnswer,
                    chooseAnswer: selectAnswer
                )
                .frame(maxWidth: 560)
                .padding(.horizontal, 12)
                .id(question.id)
                .transition(.push(from: .trailing).combined(with: .opacity))
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if let selectedAnswer {
                VStack(spacing: 8) {
                    QuizFeedbackView(
                        isCorrect: selectedAnswer == question.correctAnswer,
                        correctAnswer: question.correctAnswer,
                        animationTrigger: feedbackAnimationTrigger
                    )

                    Label(swipePrompt, systemImage: "hand.draw.fill")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .symbolEffect(.wiggle.forward, value: feedbackAnimationTrigger)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 6)
                .background(.bar)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 30)
                .onEnded(handleSwipe)
        )
        .accessibilityAction(named: Text(swipePrompt)) {
            guard selectedAnswer != nil else { return }
            advance()
        }
    }

    private var results: some View {
        QuizResultView(
            ranOutOfLives: lives == 0,
            quizScore: quizScore,
            questionCount: questions.count,
            totalScore: totalScore,
            restart: restart
        )
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No Quiz Available",
            systemImage: "questionmark.circle",
            description: Text(
                "Questions for \(region.displayName) have not been added yet."
            )
        )
    }

    private var swipePrompt: String {
        currentQuestionIndex + 1 == questions.count
            ? "Swipe left to see results"
            : "Swipe left for the next question"
    }

    private func selectAnswer(_ answer: String) {
        guard selectedAnswer == nil else {
            return
        }

        let isCorrect = answer == questions[currentQuestionIndex].correctAnswer

        withAnimation(.spring(duration: 0.3, bounce: 0.25)) {
            selectedAnswer = answer
            feedbackAnimationTrigger += 1

            if isCorrect {
                quizScore += 1
                totalScore += 1
                correctFeedbackTrigger += 1
            } else {
                lives -= 1
                totalScore = max(0, totalScore - 1)
                incorrectFeedbackTrigger += 1
            }
        }
    }

    private func advance() {
        guard selectedAnswer != nil else {
            return
        }

        let hasAnotherQuestion = currentQuestionIndex + 1 < questions.count

        guard hasAnotherQuestion, lives > 0 else {
            isFinished = true
            return
        }

        currentQuestionIndex += 1
        selectedAnswer = nil
        shuffledAnswers = questions[currentQuestionIndex].answers.shuffled()
    }

    private func handleSwipe(_ value: DragGesture.Value) {
        guard selectedAnswer != nil else { return }

        let translation = value.translation
        let isHorizontal = abs(translation.width) > abs(translation.height)
        guard isHorizontal, translation.width < -80 else { return }

        withAnimation(.snappy(duration: 0.4)) {
            advance()
        }
    }

    private func restart() {
        currentQuestionIndex = 0
        lives = 3
        quizScore = 0
        selectedAnswer = nil
        shuffledAnswers = questions.first?.answers.shuffled() ?? []
        isFinished = false
    }
}

#Preview {
    NavigationStack {
        QuizView(region: .asia)
    }
}
