import SwiftUI

struct FactCardView: View {
    let fact: CultureFact
    let isSaved: Bool
    let onToggleSave: () -> Void
    let onTapCard: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .top) {
                factImage
                imageOverlay
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(fact.title)
                    .font(.title3.weight(.bold))
                    .lineLimit(2)

                Text(fact.catchyHook)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text("Tap to read full fact →")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 4)
            }
            .padding(16)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTapCard)
        .accessibilityAction(named: "Read full fact", onTapCard)
    }

    private var factImage: some View {
        Group {
            if let uiImage = UIImage(named: fact.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .cyan.opacity(0.25),
                                .blue.opacity(0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        Image(systemName: "photo.artframe")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    }
            }
        }
        .frame(height: 190)
        .clipped()
    }

    private var imageOverlay: some View {
        HStack {
            HStack(spacing: 6) {
                Text(fact.flag)
                    .accessibilityHidden(true)

                Text(fact.country)
                    .font(.caption.weight(.bold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(.white.opacity(0.4), lineWidth: 0.6)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(fact.country)

            Spacer()

            SaveFactButton(
                isSaved: isSaved,
                presentation: .compact,
                action: onToggleSave
            )
        }
        .padding(12)
    }
}

struct SaveFactButton: View {
    enum Presentation {
        case compact
        case labeled
    }

    let isSaved: Bool
    let presentation: Presentation
    let action: () -> Void

    var body: some View {
        Group {
            switch presentation {
            case .compact:
                compactButton
            case .labeled:
                labeledButton
            }
        }
        .accessibilityLabel(isSaved ? "Remove bookmark" : "Save fact")
        .accessibilityValue(isSaved ? "Saved" : "Not saved")
        .accessibilityAddTraits(isSaved ? .isSelected : [])
        .sensoryFeedback(.selection, trigger: isSaved)
    }

    private var compactButton: some View {
        Button(action: action) {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(isSaved ? .orange : .primary)
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
    }

    private var labeledButton: some View {
        Button(action: action) {
            Label(
                isSaved ? "Saved" : "Save",
                systemImage: isSaved ? "bookmark.fill" : "bookmark"
            )
            .fontWeight(.semibold)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .tint(isSaved ? .orange : .primary)
    }
}
