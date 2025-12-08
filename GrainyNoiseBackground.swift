import SwiftUI

struct GrainyNoiseBackground: View {
    private let dotCount = 3200
    private let baseColor = Color(white: 0.94)
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 45.0)) { timeline in
            Canvas { context, size in
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .color(baseColor)
                )
                
                var generator = SeededGenerator(date: timeline.date)
                
                for _ in 0..<dotCount {
                    let x = CGFloat.random(in: 0...size.width, using: &generator)
                    let y = CGFloat.random(in: 0...size.height, using: &generator)
                    let opacity = Double.random(in: 0.05...0.25, using: &generator)
                    let diameter = CGFloat.random(in: 0.7...1.6, using: &generator)
                    let rect = CGRect(x: x, y: y, width: diameter, height: diameter)
                    
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(.black.opacity(opacity))
                    )
                }
            }
            .ignoresSafeArea()
        }
    }
}

private struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    
    init(date: Date) {
        state = UInt64(date.timeIntervalSince1970 * 1000) ^ 0x9E3779B97F4A7C15
    }
    
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}

#Preview {
    ZStack {
        GrainyNoiseBackground()
        Text("High-speed grain")
            .font(.system(size: 34, weight: .bold))
            .foregroundStyle(.black.opacity(0.75))
            .padding()
            .background(.white.opacity(0.4), in: RoundedRectangle(cornerRadius: 16))
    }
}

