//
//  AdvancedAnimations.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct PulseEffect: ViewModifier {
    @State private var isAnimating = false
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .opacity(isAnimating ? 0.8 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}

struct RippleEffect: ViewModifier {
    @State private var rippleScale: CGFloat = 0.5
    @State private var rippleOpacity: Double = 0.6
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(rippleOpacity), lineWidth: 2)
                    .scaleEffect(rippleScale)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                            rippleScale = 2.0
                            rippleOpacity = 0.0
                        }
                    }
            )
    }
}

struct GradientAnimation: ViewModifier {
    @State private var animateGradient = false
    let colors: [Color]
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: true)) {
                    animateGradient = true
                }
            }
    }
}

struct BounceEffect: ViewModifier {
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.4).repeatForever(autoreverses: true)) {
                    offset = -10
                }
            }
    }
}

struct Rotation3DEffect: ViewModifier {
    @State private var rotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0)
            )
            .onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

struct GlowEffect: ViewModifier {
    @State private var glowIntensity: Double = 0.5
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(glowIntensity), radius: 10)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    glowIntensity = 1.0
                }
            }
    }
}

extension View {
    func pulse(duration: Double = 1.0) -> some View {
        modifier(PulseEffect(duration: duration))
    }
    
    func ripple() -> some View {
        modifier(RippleEffect())
    }
    
    func animatedGradient(colors: [Color]) -> some View {
        modifier(GradientAnimation(colors: colors))
    }
    
    func bounce() -> some View {
        modifier(BounceEffect())
    }
    
    func rotate3D() -> some View {
        modifier(Rotation3DEffect())
    }
    
    func glow(color: Color = .blue) -> some View {
        modifier(GlowEffect(color: color))
    }
}

