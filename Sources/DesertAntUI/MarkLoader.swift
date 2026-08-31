import SwiftUI

/// The drop loader: the tall bar falls first, then the six cells stack in
/// from above, the mark holds, fades, and starts over.
///
/// Keep in step: this is the brand's web loader ported cell for cell
/// (packages/web/css/components/loader.css, `.loader--drop`): the same
/// 2.2s cycle, the same 140ms stagger, the same keyframes. A change on
/// either side needs the other.
extension DA {
    public struct MarkLoader: View {
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        let start = Date()

        public init() {}

        static let cycle: TimeInterval = 2.2      // --duration-loader
        static let stagger: TimeInterval = 0.14   // per-cell delay

        public var body: some View {
            GeometryReader { geo in
                let sx = geo.size.width / MarkGeometry.plate.width
                let sy = geo.size.height / MarkGeometry.plate.height
                let radius = MarkGeometry.cornerRadius * sx
                TimelineView(.animation(paused: reduceMotion)) { context in
                    let t = context.date.timeIntervalSince(start)
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: radius, style: .continuous).opacity(0.1)
                        ForEach(0..<MarkGeometry.cells.count, id: \.self) { i in
                            let c = MarkGeometry.cells[i]
                            let s = reduceMotion ? CellState.settled : Self.state(at: t, cell: i)
                            Rectangle()
                                .frame(width: c.width * sx, height: c.height * sy)
                                .offset(x: c.minX * sx, y: (c.minY + s.dropY) * sy)
                                .opacity(s.opacity)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                }
            }
            .aspectRatio(MarkGeometry.plate.width / MarkGeometry.plate.height, contentMode: .fit)
            .accessibilityLabel(Text("Loading"))
        }

        struct CellState { var dropY: CGFloat; var opacity: Double
            static let settled = CellState(dropY: 0, opacity: 1) }

        /// The web keyframes: 0% off the top and clear, 6% opaque, 18% to 78%
        /// in place, 86% to 100% gone. Before its delay a cell sits at 0%.
        static func state(at t: TimeInterval, cell: Int) -> CellState {
            let local = t - Double(cell) * stagger
            if local < 0 { return CellState(dropY: -36, opacity: 0) }
            let k = (local.truncatingRemainder(dividingBy: cycle)) / cycle
            let opacity: Double
            switch k {
            case ..<0.06: opacity = k / 0.06
            case ..<0.78: opacity = 1
            case ..<0.86: opacity = 1 - (k - 0.78) / 0.08
            default: opacity = 0
            }
            let dropY: CGFloat = k < 0.18 ? CGFloat(-36 * (1 - ease(k / 0.18))) : 0
            return CellState(dropY: dropY, opacity: opacity)
        }

        /// cubic-bezier(0.3, 0, 0.2, 1), close enough as an ease-out curve.
        static func ease(_ x: Double) -> Double { 1 - pow(1 - x, 2.6) }
    }
}
