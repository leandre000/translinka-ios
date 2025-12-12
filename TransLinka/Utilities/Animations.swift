//
//  Animations.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

extension Animation {
    static let smoothSpring = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let bouncySpring = Animation.spring(response: 0.4, dampingFraction: 0.6)
    static let gentleEase = Animation.easeInOut(duration: 0.3)
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

extension View {
    func shake(times: Int) -> some View {
        modifier(ShakeModifier(times: times))
    }
}

struct ShakeModifier: ViewModifier {
    @State private var animatableData: CGFloat = 0
    let times: Int
    
    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(animatableData: animatableData))
            .onAppear {
                withAnimation(.default) {
                    animatableData = CGFloat(times)
                }
            }
    }
}

struct FadeInModifier: ViewModifier {
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 0.5)) {
                    opacity = 1
                }
            }
    }
}

extension View {
    func fadeIn() -> some View {
        modifier(FadeInModifier())
    }
}

struct SlideInModifier: ViewModifier {
    @State private var offset: CGFloat = 50
    let direction: SlideDirection
    
    enum SlideDirection {
        case up, down, left, right
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: direction == .left ? offset : (direction == .right ? -offset : 0),
                   y: direction == .up ? offset : (direction == .down ? -offset : 0))
            .onAppear {
                withAnimation(.smoothSpring) {
                    offset = 0
                }
            }
    }
}

extension View {
    func slideIn(from direction: SlideInModifier.SlideDirection) -> some View {
        modifier(SlideInModifier(direction: direction))
    }
}

