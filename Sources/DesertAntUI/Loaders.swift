import SwiftUI

/// The brand loaders: every variant the web has, on the same cells and the
/// same clocks. `emerge-sparse` is the preferred default across the brand.
///
///     DA.Loader()                                  // emerge-sparse, in the foreground color
///     DA.Loader(.drop)
///     DA.Loader(color: DA.Color.terracotta)        // a model color, for that model's demo app
///
/// Keep in step: the four mark variants are hand ports of
/// packages/web/css/components/loader.css in Desert-Ant-Labs/brand; the grid
/// variants read `LoaderData.swift`, generated from that file. A change on
/// either side needs the other.
extension DA {
    public struct Loader: View {
        public enum Variant: String, CaseIterable, Sendable {
            case drop, chase, spin, orbit
            case fill, fillSpiral, fillRise, twinkle
            case emerge, emergeSlow, emergeDrift, emergeSparse, emergeSparseFast
            case tetris, tetrisClear
        }

        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        let variant: Variant
        let color: SwiftUI.Color?
        let start = Date()

        /// `color` tints the whole loader (the plate is the same color at 10%,
        /// as on the web). Without it the loader takes the environment
        /// foreground, so `.foregroundStyle(...)` works too.
        public init(_ variant: Variant = .emergeSparse, color: SwiftUI.Color? = nil) {
            self.variant = variant
            self.color = color
        }

        static let cycle: TimeInterval = 2.2      // --duration-loader
        static let dropStagger: TimeInterval = 0.14

        public var body: some View {
            GeometryReader { geo in
                let sx = geo.size.width / MarkGeometry.plate.width
                let sy = geo.size.height / MarkGeometry.plate.height
                let radius = MarkGeometry.cornerRadius * sx
                TimelineView(.animation(paused: reduceMotion)) { context in
                    let t = context.date.timeIntervalSince(start)
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: radius, style: .continuous).opacity(0.1)
                        if reduceMotion { MarkGlyph() } else {
                            switch variant {
                            case .drop, .chase, .spin, .orbit: markCells(t: t, sx: sx, sy: sy)
                            default: grid(t: t, sx: sx, sy: sy)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                }
            }
            .aspectRatio(MarkGeometry.plate.width / MarkGeometry.plate.height, contentMode: .fit)
            .foregroundStyle(color ?? SwiftUI.Color.primary)
            .accessibilityLabel(Text("Loading"))
        }

        // MARK: the four mark variants, on the seven cells

        @ViewBuilder func markCells(t: TimeInterval, sx: CGFloat, sy: CGFloat) -> some View {
            let spin = variant == .spin ? Angle.degrees(Double(Int((t.truncatingRemainder(dividingBy: Self.cycle)) / Self.cycle * 4)) * 90) : .zero
            ForEach(0..<MarkGeometry.cells.count, id: \.self) { i in
                let c = MarkGeometry.cells[i]
                let s = cellState(t: t, cell: i)
                Rectangle()
                    .frame(width: c.width * sx, height: c.height * sy)
                    .scaleEffect(y: s.scaleY, anchor: .center)
                    .offset(x: (c.minX + s.dx) * sx, y: (c.minY + s.dy) * sy)
                    .opacity(s.opacity)
            }
            .rotationEffect(spin)
        }

        struct CellState { var dx: CGFloat = 0; var dy: CGFloat = 0; var opacity: Double = 1; var scaleY: CGFloat = 1 }

        func cellState(t: TimeInterval, cell: Int) -> CellState {
            switch variant {
            case .drop:
                // 0% off the top and clear, 6% opaque, 18% to 78% in place, 86% gone
                let local = t - Double(cell) * Self.dropStagger
                if local < 0 { return CellState(dy: -36, opacity: 0) }
                let k = (local.truncatingRemainder(dividingBy: Self.cycle)) / Self.cycle
                let opacity: Double
                switch k {
                case ..<0.06: opacity = k / 0.06
                case ..<0.78: opacity = 1
                case ..<0.86: opacity = 1 - (k - 0.78) / 0.08
                default: opacity = 0
                }
                let dy: CGFloat = k < 0.18 ? CGFloat(-36 * (1 - Self.easeOut(k / 0.18))) : 0
                return CellState(dy: dy, opacity: opacity)
            case .chase:
                guard let track = LoaderData.chase[String(cell)] else { return CellState() }
                return CellState(opacity: Self.value(of: track, at: t))
            case .spin:
                return CellState()
            case .orbit:
                if cell == 0 {   // the bar breathes once a lap
                    let k = (t.truncatingRemainder(dividingBy: Self.cycle)) / Self.cycle
                    return CellState(scaleY: 1 - 0.18 * sin(.pi * k))
                }
                guard let keys = LoaderData.orbit[String(cell)] else { return CellState() }
                let k = (t.truncatingRemainder(dividingBy: Self.cycle)) / Self.cycle
                let key = keys.last(where: { $0.t <= k }) ?? keys[0]
                return CellState(dx: key.x, dy: key.y)
            default:
                return CellState()
            }
        }

        // MARK: the grid variants, on the five-by-five square

        static let gridX: [CGFloat] = [9.5, 13.7, 17.9, 22.1, 26.3]
        static let gridY: [CGFloat] = [7.5, 12.1, 16.7, 21.3, 25.9]
        static let pxSize = CGSize(width: 3.9, height: 4.3)
        static let markPx: Set<String> = ["2-0", "0-1", "2-1", "4-1", "1-2", "2-2", "3-2", "0-3", "2-3", "4-3", "2-4"]

        var tracks: [String: LoaderData.Track] {
            switch variant {
            case .fill: LoaderData.fill
            case .fillSpiral: LoaderData.fillSpiral
            case .fillRise: LoaderData.fillRise
            case .twinkle: LoaderData.twinkle
            case .emerge: LoaderData.emerge
            case .emergeSlow: LoaderData.emergeSlow
            case .emergeDrift: LoaderData.emergeDrift
            case .emergeSparse: LoaderData.emergeSparse
            case .emergeSparseFast: LoaderData.emergeSparseFast
            case .tetris: LoaderData.tetris
            case .tetrisClear: LoaderData.tetrisClear
            default: [:]
            }
        }

        @ViewBuilder func grid(t: TimeInterval, sx: CGFloat, sy: CGFloat) -> some View {
            let tracks = tracks
            let emergeLike: Bool = {
                switch variant { case .emerge, .emergeSlow, .emergeDrift, .emergeSparse, .emergeSparseFast: true; default: false }
            }()
            ForEach(0..<25, id: \.self) { i in
                let col = i % 5, row = i / 5, px = "\(col)-\(row)"
                let isMark = Self.markPx.contains(px)
                let opacity: Double = {
                    if let track = tracks[px] { return Self.value(of: track, at: t) }
                    if emergeLike && isMark { return 1 }        // the mark stays the picture
                    return 0.08
                }()
                RoundedRectangle(cornerRadius: 0.6 * sx, style: .continuous)
                    .frame(width: Self.pxSize.width * sx, height: Self.pxSize.height * sy)
                    .offset(x: Self.gridX[col] * sx, y: Self.gridY[row] * sy)
                    .opacity(opacity)
            }
        }

        // MARK: evaluating a CSS-shaped track

        static func value(of track: LoaderData.Track, at t: TimeInterval) -> Double {
            var local = t - track.delay
            if local < 0 { return track.keys.first?.v ?? 0.08 }   // positive delay: hold the first frame
            var k = (local.truncatingRemainder(dividingBy: track.duration)) / track.duration
            if track.alternate {
                local = t - track.delay
                let lap = Int(local / track.duration)
                if lap % 2 == 1 { k = 1 - k }
            }
            let keys = track.keys
            guard let last = keys.last else { return 0.08 }
            if track.step { return keys.last(where: { $0.t <= k })?.v ?? keys[0].v }
            guard k > keys[0].t else { return keys[0].v }
            guard k < last.t else { return last.v }
            for i in 1..<keys.count where k <= keys[i].t {
                let a = keys[i - 1], b = keys[i]
                let u = b.t == a.t ? 1 : (k - a.t) / (b.t - a.t)
                return a.v + (b.v - a.v) * Self.easeInOut(u)
            }
            return last.v
        }

        static func easeOut(_ x: Double) -> Double { 1 - pow(1 - x, 2.6) }
        static func easeInOut(_ x: Double) -> Double { x < 0.5 ? 2 * x * x : 1 - pow(-2 * x + 2, 2) / 2 }
    }

    /// The old name; `Loader` carries every variant now.
    public typealias MarkLoader = Loader
}
