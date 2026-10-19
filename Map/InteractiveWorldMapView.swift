import MapKit
import SwiftUI

struct ContinentPolygon: Identifiable {
    let id: String
    let name: String
    let polygon: MKPolygon
}

struct InteractiveWorldMapView: View {
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 50, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 130, longitudeDelta: 260)
        )
    )
    
    @State private var selectedContinent: String?
    @State private var selectionFeedbackTrigger = 0

    private let mapRegions = ContinentMapRepository.loadRegions()

    var body: some View {
        
        ZStack {
            
            /*Color(red: 0.1, green: 0.3, blue: 0.5)
                .ignoresSafeArea()*/
            Color.black
                    .ignoresSafeArea()
            
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    ForEach(mapRegions) { region in
                        MapPolygon(region.polygon)
                            .foregroundStyle(
                                selectedContinent == region.name
                                ? Color.accentColor.opacity(0.28)
                                ///: Color.clear
                                : Color(red:0.22, green: 0.45, blue: 0.28).opacity(0.85)
                            )
                            .stroke(
                                selectedContinent == region.name
                                ? Color.accentColor
                                : Color.primary.opacity(0.35),
                                lineWidth: selectedContinent == region.name ? 2 : 0.75
                            )
                    }
                }
                .mapStyle(.hybrid(elevation: .realistic))
                .overlay(
                    Color(red: 0.1, green: 0.3, blue: 0.5)
                        .opacity(0.45) // Ajusta la intensidad del azul
                        .blendMode(.multiply) // Mezcla el color con el mapa de fondo
                        .allowsHitTesting(false) // Permite que los gestos sigan pasando al mapa
                )
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }
                .onTapGesture { position in
                    guard let coordinate = proxy.convert(position, from: .local) else {
                        return
                    }
                    
                    selectContinent(at: coordinate)
                }
            }
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

    private func selectContinent(at coordinate: CLLocationCoordinate2D) {
        guard let region = mapRegions.first(where: { $0.polygon.contains(coordinate) }) else {
            return
        }

        withAnimation(.snappy) {
            selectedContinent = selectedContinent == region.name ? nil : region.name
        }
        selectionFeedbackTrigger += 1
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

private extension MKPolygon {
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
