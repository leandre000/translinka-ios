//
//  ARNavigationView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI
import ARKit
import RealityKit

struct ARNavigationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var arViewModel = ARViewModel()
    @State private var showInstructions = true
    
    var body: some View {
        ZStack {
            // AR View
            ARViewContainer(viewModel: arViewModel)
                .ignoresSafeArea()
            
            VStack {
                // Instructions Overlay
                if showInstructions {
                    VStack(spacing: Theme.spacingMedium) {
                        Text("AR Navigation")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Point your camera at the terminal to see navigation directions to your gate")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Got it") {
                            withAnimation {
                                showInstructions = false
                                arViewModel.startSession()
                            }
                        }
                        .primaryButtonStyle()
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(Theme.cornerRadiusLarge)
                    .padding()
                    .transition(.opacity)
                    .fadeIn()
                }
                
                Spacer()
                
                // AR Info Display
                if !showInstructions && arViewModel.distanceToGate > 0 {
                    VStack(spacing: Theme.spacingSmall) {
                        Text("Gate \(arViewModel.gateNumber)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("\(Int(arViewModel.distanceToGate))m away")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        HStack {
                            Image(systemName: "arrow.up")
                                .foregroundColor(.white)
                            Text(arViewModel.direction)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(Theme.cornerRadiusMedium)
                    .padding()
                    .slideIn(from: .up)
                }
                
                // AR Controls
                HStack {
                    Button(action: {
                        showInstructions = true
                    }) {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        arViewModel.resetSession()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        arViewModel.stopSession()
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            arViewModel.requestCameraPermission()
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        viewModel.setupARView(arView)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update AR view if needed
    }
}

@MainActor
class ARViewModel: ObservableObject {
    @Published var distanceToGate: Double = 0
    @Published var gateNumber: String = "A12"
    @Published var direction: String = "Straight ahead"
    
    private var arView: ARView?
    private var arSession: ARSession?
    
    func setupARView(_ view: ARView) {
        self.arView = view
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        
        view.session.run(configuration)
        self.arSession = view.session
        
        // Add coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = view.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        setupNavigationMarkers()
    }
    
    private func setupNavigationMarkers() {
        // Create 3D markers for navigation
        // In production, this would use real gate locations
        createGateMarker(at: SIMD3<Float>(0, 0, -5), gateNumber: "A12")
    }
    
    private func createGateMarker(at position: SIMD3<Float>, gateNumber: String) {
        guard let arView = arView else { return }
        
        // Create anchor
        let anchor = AnchorEntity(world: position)
        
        // Create 3D text
        let mesh = MeshResource.generateText(
            gateNumber,
            extrusionDepth: 0.1,
            font: .systemFont(ofSize: 0.5),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        
        let material = SimpleMaterial(color: .systemBlue, isMetallic: false)
        let textEntity = ModelEntity(mesh: mesh, materials: [material])
        
        // Create arrow indicator
        let arrowMesh = MeshResource.generateBox(size: [0.2, 0.2, 0.5])
        let arrowEntity = ModelEntity(mesh: arrowMesh, materials: [material])
        arrowEntity.position = [0, -0.5, 0]
        
        anchor.addChild(textEntity)
        anchor.addChild(arrowEntity)
        arView.scene.addAnchor(anchor)
        
        // Update distance
        updateDistance(to: position)
    }
    
    private func updateDistance(to position: SIMD3<Float>) {
        let distance = sqrt(
            pow(position.x, 2) +
            pow(position.y, 2) +
            pow(position.z, 2)
        )
        distanceToGate = Double(distance)
    }
    
    func startSession() {
        // Start AR tracking
    }
    
    func stopSession() {
        arSession?.pause()
    }
    
    func resetSession() {
        guard let arView = arView else { return }
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if !granted {
                print("Camera permission denied")
            }
        }
    }
}

import AVFoundation

#Preview {
    ARNavigationView()
}

