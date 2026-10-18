import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            InteractiveWorldMapView()
                .navigationTitle("World Explorer")
                .navigationBarTitleDisplayMode(.large)
                .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    HomeView()
}
