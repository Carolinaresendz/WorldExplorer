import SwiftUI

struct FactsView: View {
    private let region: WorldRegion

    @AppStorage("savedFactIDs") private var savedFactIDsStorage = ""
    @State private var showSavedOnly = false
    @State private var selectedFactForDetail: CultureFact?
    @State private var isShowingQuiz = false

    init(region: WorldRegion = .asia) {
        self.region = region
    }

    init(continent: String) {
        self.init(region: WorldRegion(continent: continent) ?? .asia)
    }

    private var selectedCategory: FactCategory {
        region.factsCategory
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                if displayedFacts.isEmpty {
                    emptyState
                } else {
                    ForEach(displayedFacts) { fact in
                        FactCardView(
                            fact: fact,
                            isSaved: savedFactIDs.contains(fact.id),
                            onToggleSave: {
                                toggleSave(for: fact.id)
                            },
                            onTapCard: {
                                selectedFactForDetail = fact
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 110)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(region.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                savedFactsButton
            }
        }
        .safeAreaInset(edge: .bottom) {
            QuizLaunchButton(regionName: region.displayName) {
                isShowingQuiz = true
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .sheet(item: $selectedFactForDetail) { fact in
            FactDetailSheet(
                fact: fact,
                isSaved: savedFactIDs.contains(fact.id),
                onToggleSave: {
                    toggleSave(for: fact.id)
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .navigationDestination(isPresented: $isShowingQuiz) {
            QuizView(region: region)
        }
    }

    private var savedFactIDs: Set<CultureFact.ID> {
        Set(
            savedFactIDsStorage
                .split(separator: "\n")
                .map(String.init)
        )
    }

    private var displayedFacts: [CultureFact] {
        if showSavedOnly {
            return CultureFactData.facts.filter {
                savedFactIDs.contains($0.id)
            }
        }

        return CultureFactData.facts.filter {
            $0.category == selectedCategory
        }
    }

    private var totalSavedFactCount: Int {
        CultureFactData.facts.count {
            savedFactIDs.contains($0.id)
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label(
                showSavedOnly
                    ? "No Saved Facts"
                    : "No Facts Available",
                systemImage: showSavedOnly ? "bookmark.slash" : "globe"
            )
        } description: {
            Text(
                showSavedOnly
                    ? "Tap the bookmark icon on any card to save it for later."
                    : "Check back soon for more cultural facts!"
            )
        }
        .padding(.top, 80)
    }

    private var savedFactsButton: some View {
        Button {
            withAnimation(.snappy) {
                showSavedOnly.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: showSavedOnly ? "bookmark.fill" : "bookmark")
                Text("Saved (\(totalSavedFactCount))")
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(showSavedOnly ? .orange : .primary)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(
                        showSavedOnly
                            ? Color.orange.opacity(0.6)
                            : Color.white.opacity(0.45),
                        lineWidth: 0.8
                    )
            }
        }
        .accessibilityLabel(showSavedOnly ? "Show all facts" : "Show saved facts")
    }

    private func toggleSave(for id: CultureFact.ID) {
        withAnimation(.snappy) {
            var updatedIDs = savedFactIDs

            if updatedIDs.contains(id) {
                updatedIDs.remove(id)
            } else {
                updatedIDs.insert(id)
            }

            savedFactIDsStorage = updatedIDs.sorted().joined(separator: "\n")
        }
    }
}

#Preview {
    NavigationStack {
        FactsView()
    }
}
