import SwiftUI

extension DS {
    /// A small marching-row loader: five dots scaling in phase, evoking a
    /// foraging line of ants. Decisive timing (no bounce or overshoot),
    /// matching the motion tokens in `design-system/tokens/motion.css`.
    ///
    /// Use anywhere a `ProgressView()` would feel too generic — model load,
    /// first-token, the precompile that precedes a demo.
    ///
    ///     SwarmLoader()                          // default 5 dots, cobalt
    ///     SwarmLoader(count: 7, color: .red)
    ///
    public struct SwarmLoader: View {
        let count: Int
        let dotSize: CGFloat
        let spacing: CGFloat
        let color: SwiftUI.Color
        let period: Double

        @State private var phase: Double = 0

        public init(count: Int = 5,
                    dotSize: CGFloat = 6,
                    spacing: CGFloat = 8,
                    color: SwiftUI.Color? = nil,
                    period: Double = 1.1) {
            self.count = count
            self.dotSize = dotSize
            self.spacing = spacing
            self.color = color ?? DS.Color.accent
            self.period = period
        }

        public var body: some View {
            HStack(spacing: spacing) {
                ForEach(0..<count, id: \.self) { i in
                    Circle()
                        .fill(color)
                        .frame(width: dotSize, height: dotSize)
                        .scaleEffect(scale(for: i))
                        .opacity(opacity(for: i))
                }
            }
            .onAppear { startMarching() }
            .accessibilityLabel("Loading")
        }

        private func scale(for index: Int) -> CGFloat {
            let lead = Double(index) / Double(max(1, count))
            let t = (phase - lead).truncatingRemainder(dividingBy: 1)
            let s = max(0, sin(t * .pi))
            return 0.55 + 0.85 * s
        }

        private func opacity(for index: Int) -> Double {
            let lead = Double(index) / Double(max(1, count))
            let t = (phase - lead).truncatingRemainder(dividingBy: 1)
            return 0.35 + 0.65 * max(0, sin(t * .pi))
        }

        private func startMarching() {
            withAnimation(.linear(duration: period).repeatForever(autoreverses: false)) {
                phase = 1.0
            }
        }
    }
}
