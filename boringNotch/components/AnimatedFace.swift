//
//  AnimatedFace.swift
//
// Created by Harsh Vardhan  Goswami  on  04/08/24.
//

import SwiftUI

struct MinimalFaceFeatures: View {
    @State private var isBlinking = false
    @State var height:CGFloat = 20;
    @State var width:CGFloat = 30;
    
    var body: some View {
        VStack(spacing: 4) { // Adjusted spacing to fit within 30x30
            // Eyes
            HStack(spacing: 4) { // Adjusted spacing to fit within 30x30
                Eye(isBlinking: $isBlinking)
                Eye(isBlinking: $isBlinking)
            }
            
            // Nose and mouth combined
            VStack(spacing: 2) { // Adjusted spacing to fit within 30x30
                // Nose
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: 3, height: 4)
                
                // Mouth (happy)
                GeometryReader { geometry in
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        path.move(to: CGPoint(x: 0, y: height / 2))
                        path.addQuadCurve(to: CGPoint(x: width, y: height / 2), control: CGPoint(x: width / 2, y: height))
                    }
                    .stroke(Color.white, lineWidth: 2)
                }
                .frame(width: 14, height: 10)
            }
        }
        .frame(width: self.width, height: self.height) // Maximum size of face
        .onAppear {
            startBlinking()
        }
    }
    
    func startBlinking() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation(.spring(duration: 0.2)) {
                isBlinking = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(duration: 0.2)) {
                    isBlinking = false
                }
            }
        }
    }
}

struct Eye: View {
    @Binding var isBlinking: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width: 4, height: isBlinking ? 1 : 4)
            .frame(maxWidth: 15, maxHeight: 15) // Adjusted max size
            .animation(.easeInOut(duration: 0.1), value: isBlinking)
    }
}

struct CigaretteIcon: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 1) {
                SmokeTrail(horizontalOffset: 0, duration: 1.4, delay: 0)
                SmokeTrail(horizontalOffset: 3, duration: 1.7, delay: 0.6)
            }
            .offset(x: 4, y: -7)

            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(.white.opacity(0.9))
                    .frame(width: 18, height: 4)

                RoundedRectangle(cornerRadius: 1)
                    .fill(.orange)
                    .frame(width: 4, height: 4)
            }
            .rotationEffect(.degrees(-8))
        }
        .frame(width: 30, height: 20)
    }
}

private struct SmokeTrail: View {
    let horizontalOffset: CGFloat
    let duration: Double
    let delay: Double
    @State private var isRising = false

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 4, y: 10))
            path.addCurve(
                to: CGPoint(x: 7, y: 0),
                control1: CGPoint(x: 0, y: 7),
                control2: CGPoint(x: 11, y: 4)
            )
        }
        .stroke(.white.opacity(0.8), style: StrokeStyle(lineWidth: 1.25, lineCap: .round))
        .frame(width: 10, height: 10)
        .offset(x: horizontalOffset, y: isRising ? -7 : 0)
        .opacity(isRising ? 0.15 : 0.8)
        .onAppear {
            withAnimation(
                .easeOut(duration: duration)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
            ) {
                isRising = true
            }
        }
    }
}

struct MinimalFaceFeatures_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            MinimalFaceFeatures()
        }
        .previewLayout(.fixed(width: 60, height: 60)) // Adjusted preview size for better visibility
    }
}
