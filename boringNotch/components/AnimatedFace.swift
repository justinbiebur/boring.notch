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

struct FootballPassAnimation: View {
    private let passDuration = 1.25

    var body: some View {
        TimelineView(.animation) { timeline in
            GeometryReader { geometry in
                let cycle = timeline.date.timeIntervalSinceReferenceDate
                    .truncatingRemainder(dividingBy: passDuration * 2) / passDuration
                let passingRight = cycle < 1
                let progress = passingRight ? cycle : cycle - 1
                let easedProgress = 0.5 - (cos(progress * .pi) / 2)
                let startX = geometry.size.width * (passingRight ? 0.035 : 0.965)
                let endX = geometry.size.width * (passingRight ? 0.965 : 0.035)
                let ballX = startX + ((endX - startX) * easedProgress)
                let ballY = geometry.size.height * 0.69 - (sin(progress * .pi) * 5)

                ZStack {
                    FootballPlayer(facingRight: true, isKicking: passingRight)
                        .position(x: geometry.size.width * 0.015, y: geometry.size.height * 0.54)

                    FootballPlayer(facingRight: false, isKicking: !passingRight)
                        .position(x: geometry.size.width * 0.985, y: geometry.size.height * 0.54)

                    Circle()
                        .fill(.yellow)
                        .frame(width: 9, height: 9)
                        .overlay(Circle().stroke(.black.opacity(0.75), lineWidth: 1))
                        .shadow(color: .yellow.opacity(0.8), radius: 1)
                        .position(x: ballX, y: ballY)
                }
            }
        }
    }
}

private struct FootballPlayer: View {
    let facingRight: Bool
    let isKicking: Bool

    var body: some View {
        VStack(spacing: 1) {
            Circle()
                .fill(.white)
                .frame(width: 6, height: 6)

            RoundedRectangle(cornerRadius: 1)
                .fill(.white)
                .frame(width: 5, height: 8)

            HStack(spacing: 1) {
                Capsule()
                    .fill(.white)
                    .frame(width: 3, height: 8)
                    .rotationEffect(.degrees(isKicking ? -28 : -8), anchor: .top)
                Capsule()
                    .fill(.white)
                    .frame(width: 3, height: 8)
                    .rotationEffect(.degrees(isKicking ? 34 : 8), anchor: .top)
            }
            .frame(height: 7, alignment: .top)
        }
        .frame(width: 16, height: 26, alignment: .top)
        .scaleEffect(x: facingRight ? 1 : -1, y: 1)
        .animation(.easeInOut(duration: 0.18), value: isKicking)
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
