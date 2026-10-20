import SwiftUI

struct FactDetailSheet: View {
    let fact: CultureFact
    let isSaved: Bool
    let onToggleSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                factImage
                factContent
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    private var factImage: some View {
        AsyncImage(url: fact.imageURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
            }
        }
        .frame(height: 240)
        .clipped()
    }

    private var factContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("\(fact.flag) \(fact.country) • \(fact.category.rawValue)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.blue)

                Spacer()

                bookmarkButton
            }

            Text(fact.title)
                .font(.title2.weight(.bold))

            Divider()

            Text(fact.fullFact)
                .font(.body)
                .lineSpacing(6)
                .foregroundStyle(.primary.opacity(0.9))

            Button("Got It!") {
                dismiss()
            }
            .font(.headline)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(.thinMaterial, in: Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(.white.opacity(0.5), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
            .padding(.top, 12)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }

    private var bookmarkButton: some View {
        Button(action: onToggleSave) {
            Label(
                isSaved ? "Saved" : "Save Fact",
                systemImage: isSaved ? "bookmark.fill" : "bookmark"
            )
            .font(.caption.weight(.bold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                isSaved
                    ? Color.orange.opacity(0.15)
                    : Color(.tertiarySystemFill),
                in: Capsule()
            )
            .foregroundStyle(isSaved ? .orange : .primary)
        }
    }
}
