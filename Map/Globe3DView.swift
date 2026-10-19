import SwiftUI
import SceneKit
import MapKit
import simd

struct Globe3DView: UIViewRepresentable {
    let regions: [ContinentPolygon]
    @Binding var selectedContinent: String?
    var onContinentTapped: ((String) -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = .black
        scnView.antialiasingMode = .multisampling4X
        scnView.isUserInteractionEnabled = true
        scnView.autoenablesDefaultLighting = false
        scnView.rendersContinuously = true
        scnView.isPlaying = true

        let scene = SCNScene()
        scnView.scene = scene

        // Camera
        let cameraNode = SCNNode()
        let camera = SCNCamera()
        camera.zNear = 0.1
        camera.zFar = 100.0
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 2.7)
        scene.rootNode.addChildNode(cameraNode)
        context.coordinator.cameraNode = cameraNode

        // Lighting
        let ambientLightNode = SCNNode()
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 850
        ambientLight.color = UIColor(white: 0.9, alpha: 1.0)
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)

        let dirLightNode = SCNNode()
        let dirLight = SCNLight()
        dirLight.type = .directional
        dirLight.intensity = 1100
        dirLight.color = UIColor(white: 1.0, alpha: 1.0)
        dirLightNode.light = dirLight
        dirLightNode.position = SCNVector3(3, 2, 4)
        dirLightNode.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(dirLightNode)

        // Earth Base Sphere
        let earthSphere = SCNSphere(radius: 1.0)
        earthSphere.segmentCount = 96
        let earthMaterial = SCNMaterial()
        if let earthImage = UIImage(named: "EarthMap") ?? UIImage(named: "earth_map") {
            earthMaterial.diffuse.contents = earthImage
        } else {
            earthMaterial.diffuse.contents = UIColor(red: 0.1, green: 0.25, blue: 0.45, alpha: 1.0)
        }
        earthMaterial.roughness.contents = 0.8
        earthSphere.materials = [earthMaterial]

        let earthNode = SCNNode(geometry: earthSphere)
        // Initial orientation: Center Americas/Europe nicely
        let initialRotY = simd_quatf(angle: -Float.pi / 2, axis: simd_float3(0, 1, 0))
        let initialRotX = simd_quatf(angle: 0.2, axis: simd_float3(1, 0, 0))
        earthNode.simdOrientation = initialRotX * initialRotY
        scene.rootNode.addChildNode(earthNode)
        context.coordinator.earthNode = earthNode

        // Overlay Sphere for continent borders and highlight
        let overlaySphere = SCNSphere(radius: 1.002)
        overlaySphere.segmentCount = 96
        let overlayMaterial = SCNMaterial()
        overlayMaterial.isDoubleSided = false
        overlayMaterial.writesToDepthBuffer = false
        overlayMaterial.readsFromDepthBuffer = true
        overlaySphere.materials = [overlayMaterial]

        let overlayNode = SCNNode(geometry: overlaySphere)
        earthNode.addChildNode(overlayNode)
        context.coordinator.overlayNode = overlayNode
        context.coordinator.overlayMaterial = overlayMaterial

        // Atmosphere halo
        let atmosphereSphere = SCNSphere(radius: 1.025)
        atmosphereSphere.segmentCount = 48
        let atmosphereMaterial = SCNMaterial()
        atmosphereMaterial.diffuse.contents = UIColor(red: 0.35, green: 0.65, blue: 1.0, alpha: 0.14)
        atmosphereMaterial.isDoubleSided = false
        atmosphereMaterial.writesToDepthBuffer = false
        atmosphereSphere.materials = [atmosphereMaterial]
        let atmosphereNode = SCNNode(geometry: atmosphereSphere)
        earthNode.addChildNode(atmosphereNode)

        // Gestures
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        panGesture.delegate = context.coordinator
        panGesture.cancelsTouchesInView = false
        scnView.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        pinchGesture.delegate = context.coordinator
        scnView.addGestureRecognizer(pinchGesture)

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        tapGesture.delegate = context.coordinator
        tapGesture.cancelsTouchesInView = false
        scnView.addGestureRecognizer(tapGesture)

        context.coordinator.scnView = scnView
        context.coordinator.updateOverlayTexture()

        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.updateOverlayTexture()
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: Globe3DView
        weak var scnView: SCNView?
        weak var cameraNode: SCNNode?
        weak var earthNode: SCNNode?
        weak var overlayNode: SCNNode?
        weak var overlayMaterial: SCNMaterial?

        private var lastRenderedContinent: String?
        private var textureCache: [String: UIImage] = [:]
        private var displayLink: CADisplayLink?
        private var angularVelocity = CGPoint.zero

        init(_ parent: Globe3DView) {
            self.parent = parent
        }

        deinit {
            displayLink?.invalidate()
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let earthNode else { return }

            if gesture.state == .began {
                stopInertia()
            }

            let translation = gesture.translation(in: gesture.view)
            let sensitivity: Float = 0.005

            let deltaX = Float(translation.x) * sensitivity
            let deltaY = Float(translation.y) * sensitivity

            // Rotate smoothly around world axes
            let rotY = simd_quatf(angle: deltaX, axis: simd_float3(0, 1, 0))
            let rotX = simd_quatf(angle: deltaY, axis: simd_float3(1, 0, 0))
            earthNode.simdOrientation = rotY * rotX * earthNode.simdOrientation

            gesture.setTranslation(.zero, in: gesture.view)

            if gesture.state == .ended || gesture.state == .cancelled {
                let velocity = gesture.velocity(in: gesture.view)
                startInertia(velocityX: Float(velocity.x), velocityY: Float(velocity.y))
            }
        }

        private func startInertia(velocityX: Float, velocityY: Float) {
            // Scale velocity to manageable angular delta per frame
            angularVelocity = CGPoint(x: CGFloat(velocityX * 0.00008), y: CGFloat(velocityY * 0.00008))

            if displayLink == nil {
                let dl = CADisplayLink(target: self, selector: #selector(updateInertia))
                dl.add(to: .main, forMode: .common)
                displayLink = dl
            }
        }

        private func stopInertia() {
            displayLink?.invalidate()
            displayLink = nil
            angularVelocity = .zero
        }

        @objc private func updateInertia() {
            guard let earthNode else {
                stopInertia()
                return
            }

            let rotY = simd_quatf(angle: Float(angularVelocity.x), axis: simd_float3(0, 1, 0))
            let rotX = simd_quatf(angle: Float(angularVelocity.y), axis: simd_float3(1, 0, 0))
            earthNode.simdOrientation = rotY * rotX * earthNode.simdOrientation

            // Smooth decay
            angularVelocity.x *= 0.94
            angularVelocity.y *= 0.94

            if abs(angularVelocity.x) < 0.0001 && abs(angularVelocity.y) < 0.0001 {
                stopInertia()
            }
        }

        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let cameraNode else { return }
            let scale = Float(gesture.scale)
            let targetZ = cameraNode.position.z / scale
            cameraNode.position.z = max(1.7, min(4.2, targetZ))
            gesture.scale = 1.0
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            stopInertia()

            guard let scnView, let earthNode else { return }
            let location = gesture.location(in: scnView)

            let hits = scnView.hitTest(location, options: [
                .firstFoundOnly: false,
                .rootNode: earthNode
            ])

            guard let hit = hits.first(where: { $0.node == earthNode || $0.node == self.overlayNode }) ?? hits.first else {
                return
            }

            let uv = hit.textureCoordinates(withMappingChannel: 0)

            // Convert UV back to latitude and longitude
            let longitude = Double(uv.x) * 360.0 - 180.0
            let latitude = 90.0 - Double(uv.y) * 180.0
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            if let matchedRegion = parent.regions.first(where: { $0.polygon.contains(coordinate) }) {
                parent.onContinentTapped?(matchedRegion.name)
            }
        }

        func updateOverlayTexture() {
            let currentSelection = parent.selectedContinent
            if currentSelection == lastRenderedContinent && overlayMaterial?.diffuse.contents != nil {
                return
            }
            lastRenderedContinent = currentSelection

            let cacheKey = currentSelection ?? "__none__"
            if let cached = textureCache[cacheKey] {
                overlayMaterial?.diffuse.contents = cached
                return
            }

            let texture = renderOverlayImage(selectedContinent: currentSelection)
            textureCache[cacheKey] = texture
            overlayMaterial?.diffuse.contents = texture
        }

        private func renderOverlayImage(selectedContinent: String?) -> UIImage {
            let size = CGSize(width: 2048, height: 1024)
            let renderer = UIGraphicsImageRenderer(size: size)

            return renderer.image { ctx in
                let cgContext = ctx.cgContext

                for region in parent.regions {
                    let isSelected = region.name == selectedContinent
                    let path = CGMutablePath()

                    let points = region.polygon.points()
                    let count = region.polygon.pointCount
                    guard count > 0 else { continue }

                    var isFirst = true
                    var prevLongitude: Double = 0

                    for i in 0..<count {
                        let coord = points[i].coordinate
                        let x = CGFloat((coord.longitude + 180.0) / 360.0) * size.width
                        let y = CGFloat((90.0 - coord.latitude) / 180.0) * size.height

                        // Prevent seam tearing across the 180th meridian
                        if isFirst || abs(coord.longitude - prevLongitude) > 180 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        prevLongitude = coord.longitude
                        isFirst = false
                    }
                    path.closeSubpath()

                    // Highlight selected continent
                    if isSelected {
                        cgContext.addPath(path)
                        cgContext.setFillColor(UIColor.systemTeal.withAlphaComponent(0.35).cgColor)
                        cgContext.fillPath()
                    }

                    // Stroke continent borders
                    cgContext.addPath(path)
                    let strokeColor = isSelected ? UIColor.systemTeal : UIColor.white.withAlphaComponent(0.28)
                    let lineWidth: CGFloat = isSelected ? 3.0 : 1.2
                    cgContext.setStrokeColor(strokeColor.cgColor)
                    cgContext.setLineWidth(lineWidth)
                    cgContext.strokePath()
                }
            }
        }
    }
}
