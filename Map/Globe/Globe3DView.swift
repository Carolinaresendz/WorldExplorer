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
        scnView.rendersContinuously = false
        scnView.isPlaying = false
        scnView.preferredFramesPerSecond = 60

        let scene = SCNScene()
        scnView.scene = scene

        // Telephoto camera setup:
        let cameraNode = SCNNode()
        let camera = SCNCamera()
        camera.fieldOfView = 22
        camera.zNear = 0.1
        camera.zFar = 100.0
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 13.0)
        scene.rootNode.addChildNode(cameraNode)
        scnView.pointOfView = cameraNode
        context.coordinator.cameraNode = cameraNode

        // A cool fill light preserves detail on the night side without flattening the globe.
        let ambientLightNode = SCNNode()
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 180
        ambientLight.color = UIColor(red: 0.44, green: 0.52, blue: 0.68, alpha: 1.0)
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)

        let dirLightNode = SCNNode()
        let dirLight = SCNLight()
        dirLight.type = .directional
        dirLight.intensity = 1_150
        dirLight.color = UIColor(red: 1.0, green: 0.95, blue: 0.84, alpha: 1.0)
        dirLight.castsShadow = true
        dirLight.shadowRadius = 8
        dirLight.shadowSampleCount = 16
        dirLightNode.light = dirLight
        dirLightNode.position = SCNVector3(2, 3, 5)
        dirLightNode.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(dirLightNode)

        // Earth Base Sphere
        let earthSphere = SCNSphere(radius: 1.0)
        earthSphere.segmentCount = 96
        let earthMaterial = SCNMaterial()
        earthMaterial.lightingModel = .physicallyBased
        earthMaterial.diffuse.contents = UIColor(red: 0.035, green: 0.12, blue: 0.24, alpha: 1.0)
        if let earthImage = UIImage(named: "EarthMap") ?? UIImage(named: "earth_map") {
            earthMaterial.diffuse.contents = earthImage
        }
        earthMaterial.metalness.contents = 0.0
        earthMaterial.roughness.contents = 0.62
        earthMaterial.specular.contents = UIColor(white: 0.42, alpha: 1.0)
        earthMaterial.diffuse.mipFilter = .linear
        earthMaterial.diffuse.magnificationFilter = .linear
        earthMaterial.diffuse.minificationFilter = .linear
        earthSphere.materials = [earthMaterial]

        let earthNode = SCNNode(geometry: earthSphere)
        // Neutral initial orientation (equator centered in front of the camera)
        let initialRotY = simd_quatf(angle: -Float.pi / 2, axis: simd_float3(0, 1, 0))
        earthNode.simdOrientation = initialRotY
        scene.rootNode.addChildNode(earthNode)
        context.coordinator.earthNode = earthNode

        // Overlay Sphere for continent borders and highlight
        let overlaySphere = SCNSphere(radius: 1.003)
        overlaySphere.segmentCount = 96
        let overlayMaterial = SCNMaterial()
        // SceneKit defaults new materials to white. Start transparent so the
        // overlay cannot hide the Earth while its generated texture is loading.
        overlayMaterial.lightingModel = .constant
        overlayMaterial.diffuse.contents = UIColor.clear
        overlayMaterial.transparent.contents = UIColor.clear
        overlayMaterial.blendMode = .alpha
        overlayMaterial.isDoubleSided = false
        overlayMaterial.writesToDepthBuffer = false
        overlayMaterial.readsFromDepthBuffer = true
        overlaySphere.materials = [overlayMaterial]

        let overlayNode = SCNNode(geometry: overlaySphere)
        earthNode.addChildNode(overlayNode)
        context.coordinator.overlayNode = overlayNode
        context.coordinator.overlayMaterial = overlayMaterial

        // Fresnel shading concentrates the atmosphere at the planet's edge.
        let atmosphereSphere = SCNSphere(radius: 1.022)
        atmosphereSphere.segmentCount = 96
        let atmosphereMaterial = SCNMaterial()
        atmosphereMaterial.lightingModel = .constant
        atmosphereMaterial.diffuse.contents = UIColor.clear
        atmosphereMaterial.blendMode = .add
        atmosphereMaterial.isDoubleSided = true
        atmosphereMaterial.writesToDepthBuffer = false
        atmosphereMaterial.readsFromDepthBuffer = true
        atmosphereMaterial.shaderModifiers = [
            .surface: """
            #pragma body
            float rim = 1.0 - saturate(abs(dot(_surface.normal, _surface.view)));
            rim = pow(rim, 4.8);
            _surface.diffuse = float4(0.18, 0.48, 1.0, 1.0);
            _surface.transparent = rim * 0.28;
            """
        ]
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

        // Prepare textures and shaders before the first visible frame.
        _ = scnView.prepare(scene, shouldAbortBlock: nil)
        scnView.setNeedsDisplay()

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
        private var currentYaw: Float = -.pi / 2
        private var currentPitch: Float = 0.0
        // Keep the globe close to upright while allowing a small north/south tilt.
        private let maxPitch: Float = 0.18
        private var lastFrameTimestamp: CFTimeInterval?

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
            let horizontalSensitivity: Float = 0.005
            let verticalSensitivity: Float = 0.0008

            let deltaX = Float(translation.x) * horizontalSensitivity
            let deltaY = Float(translation.y) * verticalSensitivity

            currentYaw += deltaX
            currentPitch = max(-maxPitch, min(maxPitch, currentPitch + deltaY))
            applyOrientation(to: earthNode)
            scnView?.setNeedsDisplay()

            gesture.setTranslation(.zero, in: gesture.view)

            if gesture.state == .ended || gesture.state == .cancelled {
                let velocity = gesture.velocity(in: gesture.view)
                startInertia(velocityX: Float(velocity.x), velocityY: Float(velocity.y))
            }
        }

        private func startInertia(velocityX: Float, velocityY: Float) {
            angularVelocity = CGPoint(x: CGFloat(velocityX * 0.0048), y: CGFloat(velocityY * 0.0002))
            lastFrameTimestamp = nil

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
            lastFrameTimestamp = nil
        }

        @objc private func updateInertia() {
            guard let earthNode else {
                stopInertia()
                return
            }

            guard let displayLink else { return }
            let previousTimestamp = lastFrameTimestamp ?? displayLink.timestamp
            let deltaTime = min(displayLink.timestamp - previousTimestamp, 1.0 / 20.0)
            lastFrameTimestamp = displayLink.timestamp

            currentYaw += Float(angularVelocity.x * deltaTime)
            currentPitch = max(-maxPitch, min(maxPitch, currentPitch + Float(angularVelocity.y * deltaTime)))
            applyOrientation(to: earthNode)
            scnView?.setNeedsDisplay()

            let horizontalDecay = pow(0.91, deltaTime * 60)
            let verticalDecay = pow(0.90, deltaTime * 60)
            angularVelocity.x *= horizontalDecay
            angularVelocity.y *= verticalDecay

            if abs(angularVelocity.x) < 0.006 && abs(angularVelocity.y) < 0.006 {
                stopInertia()
            }
        }

        private func applyOrientation(to earthNode: SCNNode) {
            let yaw = simd_quatf(angle: currentYaw, axis: simd_float3(0, 1, 0))
            let pitch = simd_quatf(angle: currentPitch, axis: simd_float3(1, 0, 0))
            earthNode.simdOrientation = yaw * pitch
        }

        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let cameraNode else { return }
            let scale = Float(gesture.scale)
            let targetZ = cameraNode.position.z / scale
            cameraNode.position.z = max(8.0, min(20.0, targetZ))
            gesture.scale = 1.0
            scnView?.setNeedsDisplay()
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
                overlayMaterial?.transparent.contents = UIColor.white
                overlayMaterial?.diffuse.contents = cached
                scnView?.setNeedsDisplay()
                return
            }

            let texture = renderOverlayImage(selectedContinent: currentSelection)
            textureCache[cacheKey] = texture
            overlayMaterial?.transparent.contents = UIColor.white
            overlayMaterial?.diffuse.contents = texture
            scnView?.setNeedsDisplay()
        }

        private func renderOverlayImage(selectedContinent: String?) -> UIImage {
            let size = CGSize(width: 1_024, height: 512)
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
