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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .ignoresSafeArea(edges: .top)
    }

    private var factImage: some View {
        Group {
            if let uiImage = UIImage(named: fact.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
            }
        }
        .frame(maxWidth: .infinity)
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

            if let credit = FactPhotoCredit.credit(for: fact),
               credit.license != "CC0" {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Photo: \(credit.author)")
                        .foregroundStyle(.secondary)

                    if let sourceURL = URL(string: credit.sourceURL),
                       let licenseURL = URL(string: credit.licenseURL) {
                        HStack {
                            Link("Wikimedia Commons", destination: sourceURL)
                            Text("·")
                            Link(credit.license, destination: licenseURL)
                        }
                    }

                    Text("Resized; cropped to fit.")
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }

            HStack {
                Spacer(minLength: 0)

                Button {
                    dismiss()
                } label: {
                    Text("Got It!")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .frame(maxWidth: 280)
                .shadow(color: .accentColor.opacity(0.2), radius: 8, y: 4)

                Spacer(minLength: 0)
            }
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }

    private var bookmarkButton: some View {
        SaveFactButton(
            isSaved: isSaved,
            presentation: .labeled,
            action: onToggleSave
        )
    }
}
