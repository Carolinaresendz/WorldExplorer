import MapKit
import SwiftUI

struct ContinentPolygon: Identifiable {
    let id: String
    let name: String
    let polygon: MKPolygon
}

struct InteractiveWorldMapView: View {
    @State private var selectedContinent: String?
    @State private var selectionFeedbackTrigger = 0

    private let mapRegions = ContinentMapRepository.loadRegions()

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            Globe3DView(
                regions: mapRegions,
                selectedContinent: $selectedContinent,
                onContinentTapped: { continent in
                    withAnimation(.snappy) {
                        selectedContinent = selectedContinent == continent ? nil : continent
                    }
                    selectionFeedbackTrigger += 1
                }
            )
            .ignoresSafeArea()
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if let selectedContinent {
                continentPanel(for: selectedContinent)
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .sensoryFeedback(.selection, trigger: selectionFeedbackTrigger)
    }

    private func continentPanel(for continent: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(displayName(for: continent), systemImage: "globe.europe.africa.fill")
                .font(.title2.bold())

            VStack(spacing: 10) {
                NavigationLink {
                    FactsView(continent: continent)
                } label: {
                    Label("Facts", systemImage: "book.pages")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                NavigationLink {
                    QuizView(continent: continent)
                } label: {
                    Label("Quiz", systemImage: "questionmark.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    private func displayName(for continent: String) -> String {
        switch continent {
        case "NorthAmerica":
            return "North America"
        case "SouthAmerica":
            return "South America"
        default:
            return continent
        }
    }
}

private enum ContinentMapRepository {
    private static let fileNames = [
        "Africa1",
        "Asia1",
        "Europe1",
        "NorthAmerica1",
        "Oceania1",
        "SouthAmerica1"
    ]

    static func loadRegions(bundle: Bundle = .main) -> [ContinentPolygon] {
        fileNames.flatMap { fileName in
            loadRegions(from: fileName, bundle: bundle)
        }
    }

    private static func loadRegions(from fileName: String, bundle: Bundle) -> [ContinentPolygon] {
        guard
            let url = bundle.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let features = try? MKGeoJSONDecoder().decode(data)
        else {
            return []
        }

        let continentName = fileName.replacingOccurrences(of: "1", with: "")
        var regions: [ContinentPolygon] = []
        var polygonIndex = 0

        for case let feature as MKGeoJSONFeature in features {
            for geometry in feature.geometry {
                if let polygon = geometry as? MKPolygon {
                    regions.append(
                        ContinentPolygon(
                            id: "\(fileName)-\(polygonIndex)",
                            name: continentName,
                            polygon: polygon
                        )
                    )
                    polygonIndex += 1
                } else if let multiPolygon = geometry as? MKMultiPolygon {
                    for polygon in multiPolygon.polygons {
                        regions.append(
                            ContinentPolygon(
                                id: "\(fileName)-\(polygonIndex)",
                                name: continentName,
                                polygon: polygon
                            )
                        )
                        polygonIndex += 1
                    }
                }
            }
        }

        return regions
    }
}

extension MKPolygon {
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        guard pointCount > 2 else {
            return false
        }

        let mapPoint = MKMapPoint(coordinate)
        let polygonPoints = points()
        var isInside = false
        var previousIndex = pointCount - 1

        for index in 0..<pointCount {
            let currentPoint = polygonPoints[index]
            let previousPoint = polygonPoints[previousIndex]

            if ((currentPoint.y > mapPoint.y) != (previousPoint.y > mapPoint.y)),
               mapPoint.x < (previousPoint.x - currentPoint.x)
                * (mapPoint.y - currentPoint.y)
                / (previousPoint.y - currentPoint.y)
                + currentPoint.x {
                isInside.toggle()
            }

            previousIndex = index
        }

        return isInside
    }
}

#Preview {
    NavigationStack {
        InteractiveWorldMapView()
            .navigationTitle("World Explorer")
            .navigationBarTitleDisplayMode(.large)
    }
}
