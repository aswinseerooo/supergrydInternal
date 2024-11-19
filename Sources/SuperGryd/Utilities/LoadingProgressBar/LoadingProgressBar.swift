//
//  LoadingProgressBar.swift
//  
//
//  Created by Aswin V Shaji on 29/10/24.
//

import SwiftUI

struct LoadingProgressBar: View {
    @State private var progress: Double = 0.0
    @State private var isForward = true
    private let animationDuration: TimeInterval = 1.0

    var body: some View {
        ProgressView(value: progress)
            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            .scaleEffect(x: 1, y: 2, anchor: .center) // Adjust thickness if needed
            .frame(height: 6)
            .cornerRadius(15)
            .onAppear {
                // Timer to animate back and forth between 0 and 1
                Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        if isForward {
                            progress = 1.0
                        } else {
                            progress = 0.0
                        }
                        isForward.toggle()
                    }
                }
            }
    }
}

#Preview {
    LoadingProgressBar()
}
