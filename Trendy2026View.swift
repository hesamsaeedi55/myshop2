//
//  Trendy2026View.swift
//  Modern Glassmorphism & Deformed Background Design
//  Trendy 2026 UI Design
//

import SwiftUI

struct Trendy2026View: View {
    @State private var animateShapes = false
    @State private var lightIntensity: Double = 0.6
    @State private var rotationAngle: Double = 0
    @State private var morphOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var selectedButton: Int? = nil
    
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.1, green: 0.05, blue: 0.2),
                    Color(red: 0.15, green: 0.1, blue: 0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated deformed shapes layer
            deformedShapesLayer
            
            // Light effects layer
            lightEffectsLayer
            
            // Content layer
            VStack(spacing: 30) {
                Spacer()
                
                // Title
                VStack(spacing: 12) {
                    Text("2026")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .cyan.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .cyan.opacity(0.5), radius: 20, x: 0, y: 0)
                    
                    Text("Future is Now")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Glass buttons
                VStack(spacing: 24) {
                    glassButton(
                        title: "Explore",
                        icon: "sparkles",
                        gradient: [.cyan, .blue],
                        index: 0
                    )
                    
                    glassButton(
                        title: "Discover",
                        icon: "star.fill",
                        gradient: [.purple, .pink],
                        index: 1
                    )
                    
                    glassButton(
                        title: "Create",
                        icon: "wand.and.stars",
                        gradient: [.orange, .red],
                        index: 2
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Deformed Shapes Layer
    private var deformedShapesLayer: some View {
        ZStack {
            // Large morphing blob 1
            MorphingBlob(
                morphOffset: morphOffset,
                color: Color.cyan.opacity(0.15),
                size: 300
            )
            .position(x: 100, y: 200)
            .blur(radius: 40)
            
            // Large morphing blob 2
            MorphingBlob(
                morphOffset: morphOffset + 0.5,
                color: Color.purple.opacity(0.15),
                size: 250
            )
            .position(x: UIScreen.main.bounds.width - 80, y: 400)
            .blur(radius: 50)
            
            // Medium morphing blob 3
            MorphingBlob(
                morphOffset: morphOffset + 1.0,
                color: Color.pink.opacity(0.12),
                size: 200
            )
            .position(x: UIScreen.main.bounds.width / 2, y: 150)
            .blur(radius: 35)
            
            // Small floating shapes
            ForEach(0..<5, id: \.self) { index in
                FloatingShape(index: index)
                    .blur(radius: 20)
            }
        }
    }
    
    // MARK: - Light Effects Layer
    private var lightEffectsLayer: some View {
        ZStack {
            // Central light source
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(lightIntensity * 0.3),
                            Color.cyan.opacity(lightIntensity * 0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 300
                    )
                )
                .frame(width: 600, height: 600)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .blur(radius: 60)
            
            // Rotating light orbs
            ForEach(0..<3, id: \.self) { index in
                LightOrb(index: index, rotation: rotationAngle)
            }
        }
    }
    
    // MARK: - Glass Button
    private func glassButton(
        title: String,
        icon: String,
        gradient: [Color],
        index: Int
    ) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                selectedButton = selectedButton == index ? nil : index
            }
        }) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(title)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 24)
            .background(
                ZStack {
                    // Base glass layer with stronger blur
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .background(
                            // Additional blur layer for more glass effect
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.15),
                                            Color.white.opacity(0.05)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .blur(radius: 10)
                        )
                    
                    // Gradient tint overlay
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: gradient.map { $0.opacity(0.15) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Glass top edge highlight (light reflection)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .frame(height: 40)
                        .offset(y: -40)
                        .blur(radius: 8)
                    
                    // Glass border with realistic edges
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.3),
                                    gradient.first?.opacity(0.4) ?? .clear,
                                    gradient.last?.opacity(0.4) ?? .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                    
                    // Inner border highlight (glass edge effect)
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                    
                    // Bottom shadow edge (glass depth)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.black.opacity(0.1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .blur(radius: 2)
                    
                    // Inner glow when selected
                    if selectedButton == index {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                RadialGradient(
                                    colors: gradient.map { $0.opacity(0.4) } + [.clear],
                                    center: .center,
                                    startRadius: 50,
                                    endRadius: 150
                                )
                            )
                            .blur(radius: 20)
                    }
                }
            )
            .overlay(
                // Outer glass margin effect
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
                    .padding(1)
            )
            .shadow(color: gradient.first?.opacity(0.4) ?? .clear, radius: 25, x: 0, y: 12)
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: -2)
            .scaleEffect(selectedButton == index ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 2)
        .padding(.vertical, 2)
    }
    
    // MARK: - Animations
    private func startAnimations() {
        // Morphing animation
        withAnimation(
            .easeInOut(duration: 4)
            .repeatForever(autoreverses: true)
        ) {
            morphOffset = 1.0
        }
        
        // Rotation animation
        withAnimation(
            .linear(duration: 20)
            .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        // Pulse animation
        withAnimation(
            .easeInOut(duration: 2)
            .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.1
        }
        
        // Light intensity animation
        withAnimation(
            .easeInOut(duration: 3)
            .repeatForever(autoreverses: true)
        ) {
            lightIntensity = 0.9
        }
    }
}

// MARK: - Morphing Blob Shape
struct MorphingBlob: Shape {
    var morphOffset: CGFloat
    var color: Color
    var size: CGFloat
    
    var animatableData: CGFloat {
        get { morphOffset }
        set { morphOffset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = size / 2
        
        let points = 8
        for i in 0..<points {
            let angle = (Double(i) / Double(points)) * 2 * .pi
            let variation = sin(angle * 3 + Double(morphOffset) * 2 * .pi) * 30
            let currentRadius = radius + CGFloat(variation)
            
            let x = center.x + cos(angle) * currentRadius
            let y = center.y + sin(angle) * currentRadius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Floating Shape
struct FloatingShape: View {
    let index: Int
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    
    var body: some View {
        let colors: [Color] = [.cyan, .purple, .pink, .blue, .orange]
        let color = colors[index % colors.count]
        
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        color.opacity(0.4),
                        color.opacity(0.1),
                        .clear
                    ],
                    center: .center,
                    startRadius: 10,
                    endRadius: 60
                )
            )
            .frame(width: 120, height: 120)
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                let randomX = CGFloat.random(in: -100...100)
                let randomY = CGFloat.random(in: -200...200)
                let randomRotation = Double.random(in: 0...360)
                
                withAnimation(
                    .easeInOut(duration: Double.random(in: 3...6))
                    .repeatForever(autoreverses: true)
                ) {
                    offset = CGSize(width: randomX, height: randomY)
                    rotation = randomRotation
                }
            }
    }
}

// MARK: - Light Orb
struct LightOrb: View {
    let index: Int
    let rotation: Double
    @State private var basePosition: CGPoint = .zero
    
    var body: some View {
        let colors: [Color] = [.cyan, .purple, .pink]
        let color = colors[index % colors.count]
        let radius: CGFloat = [200, 250, 300][index % 3]
        let speed: Double = [0.5, 0.7, 0.6][index % 3]
        
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        color.opacity(0.4),
                        color.opacity(0.2),
                        .clear
                    ],
                    center: .center,
                    startRadius: 20,
                    endRadius: 80
                )
            )
            .frame(width: 160, height: 160)
            .position(
                x: basePosition.x + cos(rotation * speed * .pi / 180) * radius,
                y: basePosition.y + sin(rotation * speed * .pi / 180) * radius
            )
            .blur(radius: 30)
            .onAppear {
                basePosition = CGPoint(
                    x: UIScreen.main.bounds.width / 2,
                    y: UIScreen.main.bounds.height / 2
                )
            }
    }
}

// MARK: - Preview
#Preview {
    Trendy2026View()
}

