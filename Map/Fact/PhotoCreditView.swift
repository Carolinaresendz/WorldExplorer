import SwiftUI

struct PhotoCreditView: View {
    let credit: FactPhotoCredit

    var body: some View {
        DisclosureGroup("Photo credits") {
            VStack(alignment: .leading, spacing: 6) {
                Text("Photo: \(credit.author)")
                    .foregroundStyle(.secondary)

                if let sourceURL = URL(string: credit.sourceURL) {
                    Link("View original photo", destination: sourceURL)
                }

                if let licenseURL = URL(string: credit.licenseURL) {
                    Link(credit.license, destination: licenseURL)
                }

                Text("Displayed cropped to fit.")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
        }
        .font(.caption)
    }
}
