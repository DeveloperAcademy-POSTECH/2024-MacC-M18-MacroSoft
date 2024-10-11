//
//  CircularProgressBar.swift
//  Modak
//
//  Created by kimjihee on 10/9/24.
//

import SwiftUI

struct CircularProgressBar: View {
    var progress: Double

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 287/20, lineCap: .round))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: Color(red: 0.97, green: 0.46, blue: 0.56), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.97, green: 0.56, blue: 0.51), location: 1.00),
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 277, height: 277)
                .animation(progress >= 0.8 ? slowAnimation : .default, value: progress)
        }
    }

    private var slowAnimation: Animation {
        Animation.linear(duration: 0.4)
    }
}

#Preview {
    CircularProgressBar(progress: 1)
}


