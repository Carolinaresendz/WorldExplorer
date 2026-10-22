import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            InteractiveWorldMapView()
                .safeAreaInset(edge: .top, spacing: 0) {
                    Text("Choose your continent")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.75))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                }
                .navigationTitle("World Explorer")
                .navigationBarTitleDisplayMode(.large)
                .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    HomeView()
}
